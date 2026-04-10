#!/usr/bin/env bash
# set -euo pipefail

# ==========================================
# PostgreSQL Compliance Scanner - Ubuntu
# Author: Kiiru Maina
# ==========================================

# Output file
HOSTNAME=$(hostname)
DATE=$(date +%F)
CSV_FILE="postgres_compliance_${HOSTNAME}_${DATE}.csv"

# Initialize CSV
echo "Standard,Status,Remediation" > "$CSV_FILE"

# ==========================================
# Helper function to write CSV rows
# ==========================================
write_csv() {
    local standard="$1"
    local status="$2"
    local remediation="$3"
    echo "\"$standard\",\"$status\",\"$remediation\"" >> "$CSV_FILE"
}


# ==========================================
# Helper: Prompt for PostgreSQL credentials (only once)
# ==========================================
get_postgres_credentials() {
    # Only prompt if variables are empty
    if [[ -z "${PG_HOST:-}" || -z "${PG_PORT:-}" || -z "${PG_DB:-}" || -z "${PG_USER:-}" || -z "${PG_PASSWORD:-}" ]]; then
        echo "Some PostgreSQL checks require database access."
        read -rp "Enter PostgreSQL host (default: localhost, leave blank to skip DB checks): " PG_HOST
        PG_HOST=${PG_HOST:-localhost}

        read -rp "Enter PostgreSQL port (default: 5432, leave blank to skip DB checks): " PG_PORT
        PG_PORT=${PG_PORT:-5432}

        read -rp "Enter PostgreSQL database name (leave blank to skip DB checks): " PG_DB
        read -rp "Enter PostgreSQL username (leave blank to skip DB checks): " PG_USER
        read -s -rp "Enter PostgreSQL password (leave blank to skip DB checks): " PG_PASSWORD
        echo ""

        # Skip flag if any required info missing
        if [[ -z "$PG_DB" || -z "$PG_USER" || -z "$PG_PASSWORD" ]]; then
            SKIP_DB_CHECKS=1
            echo "Database credentials not fully provided. PostgreSQL DB checks will be skipped."
            return
        else
            SKIP_DB_CHECKS=0
        fi
    fi
}

# FIX: Corrected variable names from DB_* to PG_*
run_pg_query() {
    local query="$1"

    if [[ "$SKIP_DB_CHECKS" -eq 1 ]]; then
        echo "SKIP"
        return
    fi

    PGPASSWORD="$PG_PASSWORD" psql -U "$PG_USER" -d "$PG_DB" -h "$PG_HOST" -p "$PG_PORT" -t -c "$query" 2>/dev/null | tr -d '[:space:]'
}


# ==========================================
# CHECK 1: Authorized Package Repositories
# ==========================================
check_authorized_repos_ubuntu() {
    STANDARD="Ensure packages are obtained from authorized repositories"
    REMEDIATION="Remove unauthorized APT repositories from /etc/apt/sources.list and /etc/apt/sources.list.d/, then run apt update"

    AUTHORIZED_REPOS="archive.ubuntu.com security.ubuntu.com ubuntu.com apt.postgresql.org"
    FOUND_UNAUTHORIZED=0

    # Collect repos (.list and .sources)
    REPO_URLS=$(
        grep -R "^[^#]*deb " /etc/apt/sources.list /etc/apt/sources.list.d/*.list 2>/dev/null | awk '{print $2}'
        grep -R "^[^#]*URIs:" /etc/apt/sources.list.d/*.sources 2>/dev/null | awk '{print $2}'
    )

    if [[ -z "$REPO_URLS" ]]; then
        write_csv "$STANDARD" "FAIL" "No APT repositories found. Verify system package configuration."
        return
    fi

    for URL in $REPO_URLS; do
        AUTHORIZED=0
        for AUTH in $AUTHORIZED_REPOS; do
            echo "$URL" | grep -qi "$AUTH" && AUTHORIZED=1
        done

        if [[ $AUTHORIZED -eq 0 ]]; then
            FOUND_UNAUTHORIZED=1
        fi
    done

    if [[ $FOUND_UNAUTHORIZED -eq 0 ]]; then
        write_csv "$STANDARD" "PASS" "All configured repositories are authorized"
    else
        write_csv "$STANDARD" "FAIL" "Unauthorized APT repositories detected. Remove or disable them."
    fi
}

# ==========================================
# CHECK 2: PostgreSQL Binary Package Source
# ==========================================
check_postgres_binary_source() {
    STANDARD="Ensure Installation of Binary Packages"
    REMEDIATION="Install PostgreSQL from Ubuntu official repositories or apt.postgresql.org. Remove packages from unauthorized sources."

    # Check if PostgreSQL is installed
    if ! dpkg -l | grep -q "^ii  postgresql"; then
        write_csv "$STANDARD" "FAIL" "PostgreSQL is not installed. Install from authorized repositories."
        return
    fi

    # Get package policy (repo source)
    POLICY_OUTPUT=$(apt-cache policy postgresql 2>/dev/null)

    # Extract repo URLs
    REPO_URLS=$(echo "$POLICY_OUTPUT" | grep -E "http" | awk '{print $2}' | sort -u)

    AUTHORIZED=0
    FOUND_UNAUTHORIZED=0
    UNAUTH_URL=""

    for URL in $REPO_URLS; do
        if echo "$URL" | grep -qiE "ubuntu.com|archive.ubuntu.com|security.ubuntu.com|apt.postgresql.org"; then
            AUTHORIZED=1
        else
            FOUND_UNAUTHORIZED=1
            UNAUTH_URL="$URL"
        fi
    done

    # Explicitly fail on PPAs
    if echo "$REPO_URLS" | grep -qi "launchpad.net"; then
        FOUND_UNAUTHORIZED=1
        UNAUTH_URL="Launchpad PPA detected"
    fi

    if [[ $AUTHORIZED -eq 1 && $FOUND_UNAUTHORIZED -eq 0 ]]; then
        write_csv "$STANDARD" "PASS" "PostgreSQL installed from authorized repositories"
    else
        write_csv "$STANDARD" "FAIL" "PostgreSQL installed from unauthorized repo ($UNAUTH_URL). Reinstall from Ubuntu or PGDG."
    fi
}

# ==========================================
# CHECK 3: PostgreSQL systemd Service Enabled
# ==========================================
check_postgres_systemd_service() {
    STANDARD="Ensure systemd Service Files Are Enabled"
    REMEDIATION="Enable PostgreSQL service(s) to start at boot using 'systemctl enable <service-name>' for each instance."

    # Get all PostgreSQL systemd service units
    POSTGRES_SERVICES=$(systemctl list-unit-files | grep -i "postgresql" | awk '{print $1}')

    if [[ -z "$POSTGRES_SERVICES" ]]; then
        write_csv "$STANDARD" "FAIL" "No PostgreSQL systemd services found. Install PostgreSQL or verify service names."
        return
    fi

    FOUND_DISABLED=0
    DISABLED_SERVICES=""

    # Check each service
    for SERVICE in $POSTGRES_SERVICES; do
        STATUS=$(systemctl is-enabled "$SERVICE" 2>/dev/null || echo "disabled")
        if [[ "$STATUS" != "enabled" ]]; then
            FOUND_DISABLED=1
            DISABLED_SERVICES+="$SERVICE "
        fi
    done

    if [[ $FOUND_DISABLED -eq 0 ]]; then
        write_csv "$STANDARD" "PASS" "All PostgreSQL systemd services are enabled to start at boot"
    else
        write_csv "$STANDARD" "FAIL" "The following PostgreSQL services are disabled: $DISABLED_SERVICES. Enable them with 'systemctl enable <service-name>'"
    fi
}

# ==========================================
# CHECK 4: PostgreSQL Data Cluster Initialized
# ==========================================
check_postgres_data_cluster() {
    STANDARD="Ensure Data Cluster Initialized Successfully"
    REMEDIATION="If cluster not initialized, remove the existing data directory (if any) and run 'sudo -u postgres initdb -D <data-directory>'"

    # Default Ubuntu data directory (package-based)
    DATA_DIR="/var/lib/postgresql"

    if [[ ! -d "$DATA_DIR" ]]; then
        write_csv "$STANDARD" "FAIL" "PostgreSQL data directory '$DATA_DIR' does not exist. Initialize using initdb."
        return
    fi

    FOUND_UNINITIALIZED=0

    # Check each versioned data directory
    for VERSION_DIR in "$DATA_DIR"/*; do
        if [[ -d "$VERSION_DIR" ]]; then
            if [[ ! -f "$VERSION_DIR/main/PG_VERSION" ]]; then
                FOUND_UNINITIALIZED=1
                UNINIT_DIR="$VERSION_DIR/main"
            fi
        fi
    done

    if [[ $FOUND_UNINITIALIZED -eq 0 ]]; then
        write_csv "$STANDARD" "PASS" "All PostgreSQL data clusters are initialized successfully"
    else
        write_csv "$STANDARD" "FAIL" "Data cluster directory '$UNINIT_DIR' is missing or uninitialized. Re-initialize using 'sudo -u postgres initdb -D $UNINIT_DIR'"
    fi
}

# ==========================================
# CHECK 5: Ensure postgres umask is 077
# ==========================================
check_postgres_umask() {
    STANDARD="Ensure the file permissions mask is correct"
    REMEDIATION="Set the postgres user's umask to 077 in .bash_profile (or .profile/.bashrc). Example: 'echo \"umask 077\" >> ~/.bash_profile' and then 'source ~/.bash_profile'"

    UMASK_VALUE=$(sudo -u postgres bash -c 'umask' | tr -d '[:space:]')

    if [[ "$UMASK_VALUE" == "0077" || "$UMASK_VALUE" == "077" ]]; then
        write_csv "$STANDARD" "PASS" "Postgres user's umask is correctly set to $UMASK_VALUE"
    else
        write_csv "$STANDARD" "FAIL" "Postgres user's umask is $UMASK_VALUE. Update the postgres profile to use umask 077"
    fi
}

# ==========================================
# CHECK 6: Ensure pg_wheel group exists
# ==========================================
check_pg_wheel_group() {
    STANDARD="Ensure the PostgreSQL pg_wheel group membership is correct"
    REMEDIATION="If the pg_wheel group does not exist, create it with: 'groupadd pg_wheel'. Only authorized users should be added as members."

    # Check if pg_wheel group exists
    if getent group pg_wheel > /dev/null 2>&1; then
        write_csv "$STANDARD" "PASS" "pg_wheel group exists on the system"
    else
        write_csv "$STANDARD" "FAIL" "pg_wheel group does not exist. Create it using 'groupadd pg_wheel'"
    fi
}

check_postgres_log_destination() {
    STANDARD="Ensure the log destinations are set correctly"
    REMEDIATION="Set the log_destination parameter in postgresql.conf or via ALTER SYSTEM, e.g., 'ALTER SYSTEM SET log_destination = ''csvlog'';' and reload config with 'SELECT pg_reload_conf();'"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Check skipped because database credentials were not provided"
        return
    fi

    export PGPASSWORD="$PG_PASSWORD"
    LOG_DEST=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "SHOW log_destination;" 2>/dev/null | tr -d '[:space:]')
    unset PGPASSWORD

    if [[ -z "$LOG_DEST" ]]; then
        write_csv "$STANDARD" "FAIL" "Could not connect to database or query log_destination"
        return
    fi

    if [[ "$LOG_DEST" =~ stderr|csvlog|syslog ]]; then
        write_csv "$STANDARD" "PASS" "PostgreSQL log_destination is set to '$LOG_DEST'"
    else
        write_csv "$STANDARD" "FAIL" "PostgreSQL log_destination is '$LOG_DEST'. Remediate by setting to one of: stderr, csvlog, syslog"
    fi
}


check_postgres_logging_collector() {
    STANDARD="Ensure the logging collector is enabled"
    REMEDIATION="Enable the logging_collector in postgresql.conf or via ALTER SYSTEM: 'ALTER SYSTEM SET logging_collector = ''on'';'"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Check skipped because database credentials were not provided"
        return
    fi

    export PGPASSWORD="$PG_PASSWORD"
    LOG_COLLECTOR=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "SHOW logging_collector;" 2>/dev/null | tr -d '[:space:]')
    unset PGPASSWORD

    if [[ -z "$LOG_COLLECTOR" ]]; then
        write_csv "$STANDARD" "FAIL" "Could not connect to database or query logging_collector"
        return
    fi

    if [[ "$LOG_COLLECTOR" == "on" ]]; then
        write_csv "$STANDARD" "PASS" "logging_collector is enabled"
    else
        write_csv "$STANDARD" "FAIL" "logging_collector is '$LOG_COLLECTOR'. Remediate by enabling it: 'ALTER SYSTEM SET logging_collector = ''on'';'"
    fi
}

# ==========================================
# CHECK 9: Ensure the log file destination directory is set correctly
# ==========================================
check_postgres_log_directory() {
    STANDARD="Ensure the log file destination directory is set correctly"
    REMEDIATION="Set the log_directory according to your organization's logging policy, e.g., 'ALTER SYSTEM SET log_directory=''/var/log/postgres/11'';' and reload with 'SELECT pg_reload_conf();'"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Check skipped because database credentials were not provided"
        return
    fi

    export PGPASSWORD="$PG_PASSWORD"
    LOG_DIR=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "SHOW log_directory;" 2>/dev/null | tr -d '[:space:]')
    unset PGPASSWORD

    if [[ -z "$LOG_DIR" ]]; then
        write_csv "$STANDARD" "FAIL" "Could not connect to database or query log_directory"
        return
    fi

    if [[ -n "$LOG_DIR" ]]; then
        write_csv "$STANDARD" "PASS" "PostgreSQL log_directory is set to '$LOG_DIR'"
    fi
}

# ------------------------------------------
# 10. Ensure the filename pattern for log files is set correctly
# ------------------------------------------
check_postgres_log_filename() {
    STANDARD="Ensure the filename pattern for log files is set correctly"
    REMEDIATION="Set log_filename to the desired pattern per policy, e.g., 'ALTER SYSTEM SET log_filename=''postgresql-%Y%m%d.log'';' and reload config with 'SELECT pg_reload_conf();'"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
        return
    fi

    export PGPASSWORD="$PG_PASSWORD"
    VALUE=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "SHOW log_filename;" 2>/dev/null | tr -d '[:space:]')
    unset PGPASSWORD

    if [[ -z "$VALUE" ]]; then
        write_csv "$STANDARD" "FAIL" "Could not query log_filename or value is empty. Remediate per policy"
    else
        write_csv "$STANDARD" "PASS" "log_filename is set to '$VALUE'"
    fi
}

# ------------------------------------------
# 11. Ensure the log file permissions are set correctly
# ------------------------------------------
check_postgres_log_file_mode() {
    STANDARD="Ensure the log file permissions are set correctly"
    REMEDIATION="Set log_file_mode to the desired numeric mode, e.g., 'ALTER SYSTEM SET log_file_mode=''0600'';' and reload config with 'SELECT pg_reload_conf();'"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
        return
    fi

    export PGPASSWORD="$PG_PASSWORD"
    VALUE=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "SHOW log_file_mode;" 2>/dev/null | tr -d '[:space:]')
    unset PGPASSWORD

    if [[ "$VALUE" == "0600" ]]; then
        write_csv "$STANDARD" "PASS" "log_file_mode is correctly set to '$VALUE'"
    else
        write_csv "$STANDARD" "FAIL" "log_file_mode is '$VALUE'. Remediate to '0600'"
    fi
}

# ------------------------------------------
# 12. Ensure 'log_truncate_on_rotation' is enabled
# ------------------------------------------
check_postgres_log_truncate_on_rotation() {
    STANDARD="Ensure 'log_truncate_on_rotation' is enabled"
    REMEDIATION="Enable log_truncate_on_rotation: 'ALTER SYSTEM SET log_truncate_on_rotation=''on'';' and reload with 'SELECT pg_reload_conf();'"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
        return
    fi

    export PGPASSWORD="$PG_PASSWORD"
    VALUE=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "SHOW log_truncate_on_rotation;" 2>/dev/null | tr -d '[:space:]')
    unset PGPASSWORD

    if [[ "$VALUE" == "on" ]]; then
        write_csv "$STANDARD" "PASS" "log_truncate_on_rotation is enabled"
    else
        write_csv "$STANDARD" "FAIL" "log_truncate_on_rotation is '$VALUE'. Remediate to 'on'"
    fi
}

# ------------------------------------------
# 13. Ensure the correct syslog facility is selected
# ------------------------------------------
check_postgres_syslog_facility() {
    STANDARD="Ensure the correct syslog facility is selected"
    REMEDIATION="Set syslog_facility per policy, e.g., 'ALTER SYSTEM SET syslog_facility=''LOCAL1'';' and reload with 'SELECT pg_reload_conf();'"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
        return
    fi

    export PGPASSWORD="$PG_PASSWORD"
    VALUE=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "SHOW syslog_facility;" 2>/dev/null | tr -d '[:space:]')
    unset PGPASSWORD

    if [[ -n "$VALUE" ]]; then
        write_csv "$STANDARD" "PASS" "syslog_facility is set to '$VALUE'"
    else
        write_csv "$STANDARD" "FAIL" "syslog_facility not set. Remediate per policy"
    fi
}

# ------------------------------------------
# 14. Ensure 'debug_print_parse' is disabled
# ------------------------------------------
check_postgres_debug_print_parse() {
    STANDARD="Ensure 'debug_print_parse' is disabled"
    REMEDIATION="Disable debug_print_parse: 'ALTER SYSTEM SET debug_print_parse=''off'';' and reload with 'SELECT pg_reload_conf();'"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
        return
    fi

    export PGPASSWORD="$PG_PASSWORD"
    VALUE=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "SHOW debug_print_parse;" 2>/dev/null | tr -d '[:space:]')
    unset PGPASSWORD

    if [[ "$VALUE" == "off" ]]; then
        write_csv "$STANDARD" "PASS" "debug_print_parse is disabled"
    else
        write_csv "$STANDARD" "FAIL" "debug_print_parse is '$VALUE'. Remediate to 'off'"
    fi
}

# ------------------------------------------
# 15. Ensure 'debug_print_rewritten' is disabled
# ------------------------------------------
check_postgres_debug_print_rewritten() {
    STANDARD="Ensure 'debug_print_rewritten' is disabled"
    REMEDIATION="Disable debug_print_rewritten: 'ALTER SYSTEM SET debug_print_rewritten=''off'';' and reload with 'SELECT pg_reload_conf();'"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
        return
    fi

    # FIX: Use tr -d instead of xargs
    export PGPASSWORD="$PG_PASSWORD"
    VALUE=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "SHOW debug_print_rewritten;" 2>/dev/null | tr -d '[:space:]')
    unset PGPASSWORD

    if [[ "$VALUE" == "off" ]]; then
        write_csv "$STANDARD" "PASS" "debug_print_rewritten is disabled"
    else
        write_csv "$STANDARD" "FAIL" "debug_print_rewritten is '$VALUE'. Remediate to 'off'"
    fi
}

# ------------------------------------------
# 16. Ensure 'debug_print_plan' is disabled
# ------------------------------------------
check_postgres_debug_print_plan() {
    STANDARD="Ensure 'debug_print_plan' is disabled"
    REMEDIATION="Disable debug_print_plan: 'ALTER SYSTEM SET debug_print_plan=''off'';' and reload with 'SELECT pg_reload_conf();'"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
        return
    fi

    export PGPASSWORD="$PG_PASSWORD"
    VALUE=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "SHOW debug_print_plan;" 2>/dev/null | tr -d '[:space:]')
    unset PGPASSWORD

    if [[ "$VALUE" == "off" ]]; then
        write_csv "$STANDARD" "PASS" "debug_print_plan is disabled"
    else
        write_csv "$STANDARD" "FAIL" "debug_print_plan is '$VALUE'. Remediate to 'off'"
    fi
}

check_debug_pretty_print() {
    local STANDARD="Ensure debug_pretty_print is enabled"
    local REMEDIATION="Run: alter system set debug_pretty_print = 'on'; select pg_reload_conf();"

    get_postgres_credentials
    local result
    result=$(run_pg_query "show debug_pretty_print;")

    if [[ "$result" == "SKIP" ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
    elif [[ "$result" == "on" ]]; then
        write_csv "$STANDARD" "PASS" "Enabled"
    else
        write_csv "$STANDARD" "FAIL" "$REMEDIATION"
    fi
}

check_log_connections() {
    local STANDARD="Ensure log_connections is enabled"
    local REMEDIATION="Run: alter system set log_connections = 'on'; restart PostgreSQL"

    get_postgres_credentials
    local result
    result=$(run_pg_query "show log_connections;")

    if [[ "$result" == "SKIP" ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
    elif [[ "$result" == "on" ]]; then
        write_csv "$STANDARD" "PASS" "Enabled"
    else
        write_csv "$STANDARD" "FAIL" "$REMEDIATION"
    fi
}

check_log_disconnections() {
    local STANDARD="Ensure log_disconnections is enabled"
    local REMEDIATION="Run: alter system set log_disconnections = 'on'; restart PostgreSQL"

    get_postgres_credentials
    local result
    result=$(run_pg_query "show log_disconnections;")

    if [[ "$result" == "SKIP" ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
    elif [[ "$result" == "on" ]]; then
        write_csv "$STANDARD" "PASS" "Enabled"
    else
        write_csv "$STANDARD" "FAIL" "$REMEDIATION"
    fi
}

check_log_statement() {
    local STANDARD="Ensure log_statement is set correctly"
    local EXPECTED="ddl"
    local REMEDIATION="Run: alter system set log_statement='ddl'; select pg_reload_conf();"

    get_postgres_credentials
    local result
    result=$(run_pg_query "show log_statement;")

    if [[ "$result" == "SKIP" ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
    elif [[ "$result" == "$EXPECTED" ]]; then
        write_csv "$STANDARD" "PASS" "Set to $EXPECTED"
    else
        write_csv "$STANDARD" "FAIL" "Expected $EXPECTED but found $result. $REMEDIATION"
    fi
}

# ==========================================
# CHECK: Ensure sudo is configured correctly
# ==========================================
check_postgres_sudo_configuration() {
    STANDARD="Ensure sudo is configured correctly"
    REMEDIATION="Add '%pg_wheel ALL= /bin/su - postgres' to /etc/sudoers using visudo"

    # Check if pg_wheel group exists
    if ! getent group pg_wheel >/dev/null; then
        write_csv "$STANDARD" "FAIL" "pg_wheel group does not exist. Create it and restrict membership."
        return
    fi

    # Check sudoers configuration safely
    if sudo grep -R "^[[:space:]]*%pg_wheel[[:space:]]\+ALL=.*su - postgres" /etc/sudoers /etc/sudoers.d/* 2>/dev/null | grep -q "pg_wheel"; then
        write_csv "$STANDARD" "PASS" "pg_wheel is configured for controlled sudo escalation to postgres"
    else
        write_csv "$STANDARD" "FAIL" "pg_wheel not configured in sudoers. Use visudo to add controlled rule."
    fi
}


# ==========================================
# CHECK: Ensure excessive administrative privileges are revoked
# ==========================================
check_postgres_excessive_admin_privileges() {
    STANDARD="Ensure excessive administrative privileges are revoked"
    REMEDIATION="Revoke superuser, createrole, createdb, replication privileges from non-admin roles"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
        return
    fi

    export PGPASSWORD="$PG_PASSWORD"

    QUERY="
    SELECT rolname
    FROM pg_roles
    WHERE rolname NOT IN ('postgres')
      AND (rolsuper OR rolcreaterole OR rolcreatedb OR rolreplication);"

    RESULTS=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "$QUERY" 2>/dev/null | tr -d '[:space:]')

    unset PGPASSWORD

    if [[ -z "$RESULTS" ]]; then
        write_csv "$STANDARD" "PASS" "No excessive administrative privileges detected for non-superuser roles"
    else
        write_csv "$STANDARD" "FAIL" "Roles with excessive privileges: $RESULTS. Revoke using ALTER ROLE"
    fi
}


# ==========================================
# CHECK: Ensure excessive function privileges are revoked
# ==========================================
check_postgres_security_definer_functions() {
    STANDARD="Ensure excessive function privileges are revoked"
    REMEDIATION="Review SECURITY DEFINER functions and change to SECURITY INVOKER where possible"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
        return
    fi

    export PGPASSWORD="$PG_PASSWORD"

    QUERY="
    SELECT nspname || '.' || proname
    FROM pg_proc p
    JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE prosecdef = true;"

    RESULTS=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "$QUERY" 2>/dev/null | tr -d '[:space:]')

    unset PGPASSWORD

    if [[ -z "$RESULTS" ]]; then
        write_csv "$STANDARD" "PASS" "No SECURITY DEFINER functions detected"
    else
        write_csv "$STANDARD" "FAIL" "SECURITY DEFINER functions detected: $RESULTS. Review and downgrade to SECURITY INVOKER"
    fi
}


# ==========================================
# CHECK: Ensure excessive DML privileges are revoked
# ==========================================
check_postgres_excessive_dml_privileges() {
    STANDARD="Ensure excessive DML privileges are revoked"
    REMEDIATION="Revoke INSERT, UPDATE, DELETE privileges from unauthorized roles using REVOKE"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
        return
    fi

    export PGPASSWORD="$PG_PASSWORD"

    QUERY="
    SELECT grantee || ':' || table_schema || '.' || table_name
    FROM information_schema.role_table_grants
    WHERE privilege_type IN ('INSERT','UPDATE','DELETE')
      AND grantee NOT IN ('postgres')
      AND grantee NOT LIKE 'pg_%'
    GROUP BY grantee, table_schema, table_name;"

    RESULTS=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "$QUERY" 2>/dev/null | tr -d '[:space:]')

    unset PGPASSWORD

    if [[ -z "$RESULTS" ]]; then
        write_csv "$STANDARD" "PASS" "No excessive DML privileges detected"
    else
        write_csv "$STANDARD" "FAIL" "Excessive DML privileges detected: $RESULTS. Revoke unauthorized grants"
    fi
}

# ==========================================
# CHECK: Ensure login via "host" TCP/IP Socket is configured correctly
# ==========================================
check_postgres_tcp_authentication() {
    STANDARD="Ensure login via host TCP/IP Socket is configured correctly"
    REMEDIATION="Update pg_hba.conf to use scram-sha-256 for remote host entries"
    HBA_FILE=$(sudo -u postgres psql -t -c "SHOW hba_file;" 2>/dev/null | tr -d '[:space:]')

    if [[ -z "$HBA_FILE" || ! -f "$HBA_FILE" ]]; then
        write_csv "$STANDARD" "FAIL" "Could not locate pg_hba.conf"
        return
    fi

    # Check host rules excluding localhost
    INSECURE_LINES=$(grep -E "^[[:space:]]*host" "$HBA_FILE" | grep -vE "127\.0\.0\.1|::1" | grep -E "(trust|password|ident|md5)")

    if [[ -z "$INSECURE_LINES" ]]; then
        write_csv "$STANDARD" "PASS" "Remote host authentication uses secure methods (scram-sha-256 or cert)"
    else
        write_csv "$STANDARD" "FAIL" "Insecure TCP auth methods found in pg_hba.conf: $INSECURE_LINES"
    fi
}


# ==========================================
# CHECK: Ensure backend runtime parameters are configured correctly
# ==========================================
check_postgres_backend_runtime_parameters() {
    STANDARD="Ensure backend runtime parameters are configured correctly"
    REMEDIATION="Compare pg_settings against baseline and correct deviations in postgresql.conf"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
        return
    fi

    export PGPASSWORD="$PG_PASSWORD"

    QUERY="
    SELECT name, setting FROM pg_settings
    WHERE context IN ('backend','superuser-backend')
    ORDER BY name;"

    OUTPUT=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "$QUERY" 2>/dev/null)

    unset PGPASSWORD

    if [[ -z "$OUTPUT" ]]; then
        write_csv "$STANDARD" "FAIL" "Could not query backend runtime parameters"
        return
    fi

    FAIL=0
    echo "$OUTPUT" | grep -qE "log_connections\s*\|\s*on" || FAIL=1
    echo "$OUTPUT" | grep -qE "log_disconnections\s*\|\s*on" || FAIL=1
    echo "$OUTPUT" | grep -qE "ignore_system_indexes\s*\|\s*off" || FAIL=1
    echo "$OUTPUT" | grep -qE "jit_debugging_support\s*\|\s*off" || FAIL=1
    echo "$OUTPUT" | grep -qE "jit_profiling_support\s*\|\s*off" || FAIL=1

    if [[ $FAIL -eq 0 ]]; then
        write_csv "$STANDARD" "PASS" "Backend runtime parameters match expected secure configuration"
    else
        write_csv "$STANDARD" "FAIL" "Backend runtime parameters deviate from secure baseline. Review pg_settings and configs"
    fi
}


# ==========================================
# CHECK: Ensure SSL is enabled and configured correctly
# ==========================================
check_postgres_ssl_enabled() {
    STANDARD="Ensure SSL is enabled and configured correctly"
    REMEDIATION="Enable ssl = on and configure server.crt and server.key per PostgreSQL documentation"

    get_postgres_credentials
    if [[ "${SKIP_DB_CHECKS:-1}" -eq 1 ]]; then
        write_csv "$STANDARD" "SKIPPED" "Database credentials not provided"
        return
    fi

    export PGPASSWORD="$PG_PASSWORD"
    SSL_STATUS=$(psql -h "$PG_HOST" -p "$PG_PORT" -U "$PG_USER" -d "$PG_DB" -t -c "SHOW ssl;" 2>/dev/null | tr -d '[:space:]')
    unset PGPASSWORD

    if [[ "$SSL_STATUS" == "on" ]]; then
        write_csv "$STANDARD" "PASS" "SSL is enabled on PostgreSQL"
    else
        write_csv "$STANDARD" "FAIL" "SSL is disabled. Enable ssl=on and configure certificates"
    fi
}

# ==========================================
# MAIN EXECUTION
# ==========================================
echo "Running PostgreSQL Compliance Checks on $HOSTNAME..."

check_authorized_repos_ubuntu
check_postgres_binary_source
check_postgres_systemd_service
check_postgres_umask
check_pg_wheel_group
check_postgres_log_destination
check_postgres_logging_collector
check_postgres_log_directory
check_postgres_log_filename
check_postgres_log_file_mode
check_postgres_log_truncate_on_rotation
check_postgres_syslog_facility
check_postgres_debug_print_parse
check_postgres_debug_print_rewritten
check_postgres_debug_print_plan
check_debug_pretty_print
check_log_connections
check_log_disconnections
check_log_statement
check_postgres_sudo_configuration
check_postgres_excessive_admin_privileges
check_postgres_security_definer_functions
check_postgres_excessive_dml_privileges
check_postgres_tcp_authentication
check_postgres_backend_runtime_parameters
check_postgres_ssl_enabled


echo "Compliance scan completed."
echo "Report saved to: $CSV_FILE"