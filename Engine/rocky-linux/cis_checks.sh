#!/bin/bash
section() {
    echo
    echo "================================================="
    echo "$1"
    echo "================================================="
}

PASS=0
FAIL=0

pass() { echo "[PASS] $1"; ((PASS++)); }
fail() { echo "[FAIL] $1"; ((FAIL++)); }

echo "================================================="
echo "CIS Controls: Filesystem → Before Services"
echo "Total Expected Checks: 38"
echo "================================================="

section "SECTION 1: FILESYSTEM CONFIGURATION"

############################################################
...
############################################################
# 1 Disable unused filesystems
############################################################
modprobe -n -v cramfs 2>/dev/null | grep -q "install /bin/true" \
  && pass "Disable unused filesystems" \
  || fail "Disable unused filesystems"

############################################################
# 2 Ensure mounting of squashfs filesystems is disabled
############################################################
modprobe -n -v squashfs 2>/dev/null | grep -q "install /bin/true" \
  && pass "Ensure mounting of squashfs filesystems is disabled" \
  || fail "Ensure mounting of squashfs filesystems is disabled"

############################################################
# 3 Ensure mounting of udf filesystems is disabled
############################################################
modprobe -n -v udf 2>/dev/null | grep -q "install /bin/true" \
  && pass "Ensure mounting of udf filesystems is disabled" \
  || fail "Ensure mounting of udf filesystems is disabled"

############################################################
# 4 Ensure /tmp is configured
############################################################
findmnt -n /tmp >/dev/null 2>&1 \
  && pass "Ensure /tmp is configured" \
  || fail "Ensure /tmp is configured"

############################################################
# 5 Ensure nodev option set on /tmp partition
############################################################
mount | grep -E '\s/tmp\s' | grep -q nodev \
  && pass "Ensure nodev option set on /tmp partition" \
  || fail "Ensure nodev option set on /tmp partition"

############################################################
# 6 Ensure nosuid option set on /tmp partition
############################################################
mount | grep -E '\s/tmp\s' | grep -q nosuid \
  && pass "Ensure nosuid option set on /tmp partition" \
  || fail "Ensure nosuid option set on /tmp partition"

############################################################
# 7 Ensure noexec option set on /tmp partition
############################################################
mount | grep -E '\s/tmp\s' | grep -q noexec \
  && pass "Ensure noexec option set on /tmp partition" \
  || fail "Ensure noexec option set on /tmp partition"

############################################################
# 8 Ensure separate partition exists for /var
############################################################
findmnt -n /var >/dev/null 2>&1 \
  && pass "Ensure separate partition exists for /var" \
  || fail "Ensure separate partition exists for /var"

############################################################
# 9 Ensure separate partition exists for /var/tmp
############################################################
findmnt -n /var/tmp >/dev/null 2>&1 \
  && pass "Ensure separate partition exists for /var/tmp" \
  || fail "Ensure separate partition exists for /var/tmp"

############################################################
# 10 Ensure nodev option set on /var/tmp partition
############################################################
mount | grep -E '\s/var/tmp\s' | grep -q nodev \
  && pass "Ensure nodev option set on /var/tmp partition" \
  || fail "Ensure nodev option set on /var/tmp partition"

############################################################
# 11 Ensure nosuid option set on /var/tmp partition
############################################################
mount | grep -E '\s/var/tmp\s' | grep -q nosuid \
  && pass "Ensure nosuid option set on /var/tmp partition" \
  || fail "Ensure nosuid option set on /var/tmp partition"

############################################################
# 12 Ensure noexec option set on /var/tmp partition
############################################################
mount | grep -E '\s/var/tmp\s' | grep -q noexec \
  && pass "Ensure noexec option set on /var/tmp partition" \
  || fail "Ensure noexec option set on /var/tmp partition"

############################################################
# 13 Ensure separate partition exists for /var/log
############################################################
findmnt -n /var/log >/dev/null 2>&1 \
  && pass "Ensure separate partition exists for /var/log" \
  || fail "Ensure separate partition exists for /var/log"

############################################################
# 14 Ensure separate partition exists for /var/log/audit
############################################################
findmnt -n /var/log/audit >/dev/null 2>&1 \
  && pass "Ensure separate partition exists for /var/log/audit" \
  || fail "Ensure separate partition exists for /var/log/audit"

############################################################
# 15 Ensure separate partition exists for /home
############################################################
findmnt -n /home >/dev/null 2>&1 \
  && pass "Ensure separate partition exists for /home" \
  || fail "Ensure separate partition exists for /home"

############################################################
# 16 Ensure nodev option set on /home partition
############################################################
mount | grep -E '\s/home\s' | grep -q nodev \
  && pass "Ensure nodev option set on /home partition" \
  || fail "Ensure nodev option set on /home partition"

############################################################
# 17 Ensure nosuid option set on /dev/shm partition
############################################################
mount | grep -E '\s/dev/shm\s' | grep -q nosuid \
  && pass "Ensure nosuid option set on /dev/shm partition" \
  || fail "Ensure nosuid option set on /dev/shm partition"

############################################################
# 18 Ensure noexec option set on /dev/shm partition
############################################################
mount | grep -E '\s/dev/shm\s' | grep -q noexec \
  && pass "Ensure noexec option set on /dev/shm partition" \
  || fail "Ensure noexec option set on /dev/shm partition"

############################################################
# 19 Ensure sticky bit is set on all world-writable directories
############################################################
find / -xdev -type d -perm -0002 ! -perm -1000 2>/dev/null | grep -q . \
  && fail "Ensure sticky bit is set on all world-writable directories" \
  || pass "Ensure sticky bit is set on all world-writable directories"

############################################################
# 20 Disable Automounting
############################################################
systemctl is-enabled autofs 2>/dev/null | grep -q disabled \
  && pass "Disable Automounting" \
  || fail "Disable Automounting"

############################################################
# 21 Disable USB Storage
############################################################
modprobe -n -v usb-storage 2>/dev/null | grep -q "install /bin/true" \
  && pass "Disable USB Storage" \
  || fail "Disable USB Storage"

############################################################
# 22 Ensure Red Hat Subscription Manager connection is configured
############################################################
subscription-manager status >/dev/null 2>&1 \
  && pass "Ensure Red Hat Subscription Manager connection is configured" \
  || fail "Ensure Red Hat Subscription Manager connection is configured"

############################################################
# 23 Ensure gpgcheck is globally activated
############################################################
grep -Eq '^\s*gpgcheck\s*=\s*1' /etc/dnf/dnf.conf \
  && pass "Ensure gpgcheck is globally activated" \
  || fail "Ensure gpgcheck is globally activated"

############################################################
# 24 Ensure sudo is installed
############################################################
rpm -q sudo >/dev/null 2>&1 \
  && pass "Ensure sudo is installed" \
  || fail "Ensure sudo is installed"

############################################################
# 25 Ensure sudo commands use pty
############################################################
grep -Eq '^\s*Defaults\s+.*use_pty' /etc/sudoers /etc/sudoers.d/* 2>/dev/null \
  && pass "Ensure sudo commands use pty" \
  || fail "Ensure sudo commands use pty"

############################################################
# 26 Ensure sudo log file exists
############################################################
grep -Eq '^\s*Defaults\s+.*logfile=' /etc/sudoers /etc/sudoers.d/* 2>/dev/null \
  && pass "Ensure sudo log file exists" \
  || fail "Ensure sudo log file exists"

############################################################
# 27 Ensure AIDE is installed
############################################################
rpm -q aide >/dev/null 2>&1 \
  && pass "Ensure AIDE is installed" \
  || fail "Ensure AIDE is installed"

############################################################
# 28 Ensure filesystem integrity is regularly checked
############################################################
systemctl is-enabled aidecheck.timer >/dev/null 2>&1 \
  && pass "Ensure filesystem integrity is regularly checked" \
  || fail "Ensure filesystem integrity is regularly checked"

############################################################
# 29 Ensure permissions on bootloader config are configured
############################################################
stat -Lc "%a %u %g" /boot/grub2/grub.cfg 2>/dev/null | grep -Eq '^600 0 0$' \
  && pass "Ensure permissions on bootloader config are configured" \
  || fail "Ensure permissions on bootloader config are configured"

############################################################
# 30 Ensure bootloader password is set
############################################################
grep -Eq '^\s*GRUB2_PASSWORD=' /boot/grub2/user.cfg 2>/dev/null \
  && pass "Ensure bootloader password is set" \
  || fail "Ensure bootloader password is set"

############################################################
# 31 Ensure authentication required for single user mode
############################################################
grep -Eq '^\s*ExecStart=.*sulogin' /usr/lib/systemd/system/rescue.service \
  && pass "Ensure authentication required for single user mode" \
  || fail "Ensure authentication required for single user mode"

############################################################
# 32 Ensure SELinux is installed
############################################################
rpm -q libselinux >/dev/null 2>&1 \
  && pass "Ensure SELinux is installed" \
  || fail "Ensure SELinux is installed"

############################################################
# 33 Ensure the SELinux state is enforcing
############################################################
getenforce 2>/dev/null | grep -q Enforcing \
  && pass "Ensure the SELinux state is enforcing" \
  || fail "Ensure the SELinux state is enforcing"

############################################################
# 34 Ensure SETroubleshoot is not installed
############################################################
rpm -q setroubleshoot >/dev/null 2>&1 \
  && fail "Ensure SETroubleshoot is not installed" \
  || pass "Ensure SETroubleshoot is not installed"

############################################################
# 35 Ensure permissions on /etc/motd are configured
############################################################
stat -Lc "%a %u %g" /etc/motd 2>/dev/null | grep -Eq '^644 0 0$' \
  && pass "Ensure permissions on /etc/motd are configured" \
  || fail "Ensure permissions on /etc/motd are configured"

############################################################
# 36 Ensure remote login warning banner is configured
############################################################
grep -q Banner /etc/ssh/sshd_config 2>/dev/null \
  && pass "Ensure remote login warning banner is configured" \
  || fail "Ensure remote login warning banner is configured"

############################################################
# 37 Ensure GDM login banner is configured
############################################################
[ -f /etc/dconf/db/gdm.d/01-banner-message ] \
  && pass "Ensure GDM login banner is configured" \
  || fail "Ensure GDM login banner is configured"

############################################################
# 38 Ensure updates, patches, and additional security software are installed
############################################################

if timeout 30s dnf check-update >/dev/null 2>&1; then
    pass "Ensure updates, patches, and additional security software are installed"
else
    EXIT_CODE=$?
    if [ $EXIT_CODE -eq 124 ]; then
        echo "[Check Manually] Ensure updates, patches, and additional security software are installed (Command timed out)"
    else
        fail "Ensure updates, patches, and additional security software are installed"
    fi
fi
############################################################
# Services
############################################################
section "SECTION 2: SERVICES"
############################################################
# Ensure xinetd is not installed
############################################################
rpm -q xinetd >/dev/null 2>&1 \
  && fail "Ensure xinetd is not installed" \
  || pass "Ensure xinetd is not installed"

############################################################
# Ensure chrony is configured
############################################################
systemctl is-enabled chronyd >/dev/null 2>&1 \
  && pass "Ensure chrony is configured" \
  || fail "Ensure chrony is configured"

############################################################
# Ensure X Window System is not installed
############################################################
rpm -qa | grep -q xorg-x11 \
  && fail "Ensure X Window System is not installed" \
  || pass "Ensure X Window System is not installed"

############################################################
# Ensure Samba is not enabled
############################################################
systemctl is-enabled smb >/dev/null 2>&1 \
  && fail "Ensure Samba is not enabled" \
  || pass "Ensure Samba is not enabled"

############################################################
# Ensure HTTP Proxy Server is not enabled
############################################################
systemctl is-enabled squid >/dev/null 2>&1 \
  && fail "Ensure HTTP Proxy Server is not enabled" \
  || pass "Ensure HTTP Proxy Server is not enabled"

############################################################
# Ensure RPC is not enabled
############################################################
systemctl is-enabled rpcbind >/dev/null 2>&1 \
  && fail "Ensure RPC is not enabled" \
  || pass "Ensure RPC is not enabled"

############################################################
# Ensure CUPS is not enabled
############################################################
systemctl is-enabled cups >/dev/null 2>&1 \
  && fail "Ensure CUPS is not enabled" \
  || pass "Ensure CUPS is not enabled"

############################################################
# Ensure DHCP Server is not enabled
############################################################
systemctl is-enabled dhcpd >/dev/null 2>&1 \
  && fail "Ensure DHCP Server is not enabled" \
  || pass "Ensure DHCP Server is not enabled"


section "SECTION 3: NETWORK CONFIGURATION"

############################################################
# Ensure IP forwarding is disabled
############################################################
sysctl net.ipv4.ip_forward 2>/dev/null | grep -q "= 0" \
  && pass "Ensure IP forwarding is disabled" \
  || fail "Ensure IP forwarding is disabled"

############################################################
# Ensure packet redirect sending is disabled
############################################################
sysctl net.ipv4.conf.all.send_redirects 2>/dev/null | grep -q "= 0" \
  && pass "Ensure packet redirect sending is disabled" \
  || fail "Ensure packet redirect sending is disabled"

############################################################
# Ensure suspicious packets are logged
############################################################
sysctl net.ipv4.conf.all.log_martians 2>/dev/null | grep -q "= 1" \
  && pass "Ensure suspicious packets are logged" \
  || fail "Ensure suspicious packets are logged"

############################################################
# Ensure TCP SYN Cookies is enabled
############################################################
sysctl net.ipv4.tcp_syncookies 2>/dev/null | grep -q "= 1" \
  && pass "Ensure TCP SYN Cookies is enabled" \
  || fail "Ensure TCP SYN Cookies is enabled"

############################################################
# Ensure a Firewall package is installed
############################################################
rpm -q firewalld >/dev/null 2>&1 \
  && pass "Ensure a Firewall package is installed" \
  || fail "Ensure a Firewall package is installed"

############################################################
# Ensure unnecessary services and ports are not accepted
############################################################
firewall-cmd --get-active-zones >/dev/null 2>&1 \
  && pass "Ensure unnecessary services and ports are not accepted" \
  || fail "Ensure unnecessary services and ports are not accepted"

section "SECTION 4: LOGGING AND AUDITING"

############################################################
# 1 Ensure auditd is installed
############################################################
rpm -q audit audit-libs >/dev/null 2>&1 \
  && pass "Ensure auditd is installed" \
  || fail "Ensure auditd is installed"

############################################################
# 2 Ensure auditd service is enabled
############################################################
systemctl is-enabled auditd >/dev/null 2>&1 \
  && pass "Ensure auditd service is enabled" \
  || fail "Ensure auditd service is enabled"

############################################################
# 3 Ensure audit log storage size is configured
############################################################
grep -q "^max_log_file" /etc/audit/auditd.conf 2>/dev/null \
  && pass "Ensure audit log storage size is configured" \
  || fail "Ensure audit log storage size is configured"

############################################################
# 4 Ensure changes to system administration scope (sudoers) is collected
############################################################
grep -q "scope" /etc/audit/rules.d/*.rules 2>/dev/null \
  && pass "Ensure changes to system administration scope (sudoers) is collected" \
  || fail "Ensure changes to system administration scope (sudoers) is collected"

############################################################
# 5 Ensure session initiation information is collected
############################################################
grep -E "(session|logins)" /etc/audit/rules.d/*.rules >/dev/null 2>&1 \
  && pass "Ensure session initiation information is collected" \
  || fail "Ensure session initiation information is collected"

############################################################
# 6 Ensure events that modify date and time information are collected
############################################################
grep -q "time-change" /etc/audit/rules.d/*.rules 2>/dev/null \
  && pass "Ensure events that modify date and time information are collected" \
  || fail "Ensure events that modify date and time information are collected"

############################################################
# 7 Ensure events that modify the system's Mandatory Access Controls are collected
############################################################
grep -q "MAC-policy" /etc/audit/rules.d/*.rules 2>/dev/null \
  && pass "Ensure events that modify the system's Mandatory Access Controls are collected" \
  || fail "Ensure events that modify the system's Mandatory Access Controls are collected"

############################################################
# 8 Ensure events that modify the system's network environment are collected
############################################################
grep -q "system-locale" /etc/audit/rules.d/*.rules 2>/dev/null \
  && pass "Ensure events that modify the system's network environment are collected" \
  || fail "Ensure events that modify the system's network environment are collected"

############################################################
# 9 Ensure discretionary access control permission modification events are collected
############################################################
grep -q "perm_mod" /etc/audit/rules.d/*.rules 2>/dev/null \
  && pass "Ensure discretionary access control permission modification events are collected" \
  || fail "Ensure discretionary access control permission modification events are collected"

############################################################
# 10 Ensure unsuccessful unauthorized file access attempts are collected
############################################################
grep -q "access" /etc/audit/rules.d/*.rules 2>/dev/null \
  && pass "Ensure unsuccessful unauthorized file access attempts are collected" \
  || fail "Ensure unsuccessful unauthorized file access attempts are collected"

############################################################
# 11 Record Events That Modify User/Group Information
############################################################
grep -q "identity" /etc/audit/rules.d/*.rules 2>/dev/null \
  && pass "Record Events That Modify User/Group Information" \
  || fail "Record Events That Modify User/Group Information"

############################################################
# 12 Ensure use of privileged commands is collected
############################################################
grep -q "privileged" /etc/audit/rules.d/*.rules 2>/dev/null \
  && pass "Ensure use of privileged commands is collected" \
  || fail "Ensure use of privileged commands is collected"

############################################################
# 13 Ensure file deletion events by users are collected
############################################################
grep -q "delete" /etc/audit/rules.d/*.rules 2>/dev/null \
  && pass "Ensure file deletion events by users are collected" \
  || fail "Ensure file deletion events by users are collected"

############################################################
# 14 Ensure kernel module loading and unloading is collected
############################################################
grep -q "modules" /etc/audit/rules.d/*.rules 2>/dev/null \
  && pass "Ensure kernel module loading and unloading is collected" \
  || fail "Ensure kernel module loading and unloading is collected"

############################################################
# 15 Ensure system administrator actions (sudolog) are collected
############################################################
grep -q "actions" /etc/audit/rules.d/*.rules 2>/dev/null \
  && pass "Ensure system administrator actions (sudolog) are collected" \
  || fail "Ensure system administrator actions (sudolog) are collected"

############################################################
# 16 Ensure the audit configuration is immutable
############################################################
grep -q "^-e 2" /etc/audit/rules.d/*.rules 2>/dev/null \
  && pass "Ensure the audit configuration is immutable" \
  || fail "Ensure the audit configuration is immutable"

############################################################
# 17 Install the rsyslog package
############################################################
rpm -q rsyslog >/dev/null 2>&1 \
  && pass "Install the rsyslog package" \
  || fail "Install the rsyslog package"

############################################################
# 18 Ensure rsyslog Service is enabled
############################################################
systemctl is-enabled rsyslog >/dev/null 2>&1 \
  && pass "Ensure rsyslog Service is enabled" \
  || fail "Ensure rsyslog Service is enabled"

############################################################
# 19 Ensure rsyslog is configured to send logs to a remote log host
############################################################
grep -E "^\*\.\*.*@@" /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null \
  && pass "Ensure rsyslog is configured to send logs to a remote log host" \
  || fail "Ensure rsyslog is configured to send logs to a remote log host"


section "SECTION 5: ACCESS, AUTHENTICATION AND AUTHORIZATION"

############################################################
# 1 Ensure cron daemon is enabled
############################################################
systemctl is-enabled crond >/dev/null 2>&1 \
  && pass "Ensure cron daemon is enabled" \
  || fail "Ensure cron daemon is enabled"

############################################################
# 2 Ensure permissions on /etc/crontab
############################################################
stat -Lc "%a %u %g" /etc/crontab 2>/dev/null | grep -q "^600 0 0" \
  && pass "Ensure permissions on /etc/crontab" \
  || fail "Ensure permissions on /etc/crontab"

############################################################
# 3 Ensure permissions on /etc/cron.hourly are configured
############################################################
stat -Lc "%a %u %g" /etc/cron.hourly 2>/dev/null | grep -q "^700 0 0" \
  && pass "Ensure permissions on /etc/cron.hourly are configured" \
  || fail "Ensure permissions on /etc/cron.hourly are configured"

############################################################
# 4 Ensure permissions on /etc/cron.daily are configured
############################################################
stat -Lc "%a %u %g" /etc/cron.daily 2>/dev/null | grep -q "^700 0 0" \
  && pass "Ensure permissions on /etc/cron.daily are configured" \
  || fail "Ensure permissions on /etc/cron.daily are configured"

############################################################
# 5 Ensure permissions on /etc/cron.weekly are configured
############################################################
stat -Lc "%a %u %g" /etc/cron.weekly 2>/dev/null | grep -q "^700 0 0" \
  && pass "Ensure permissions on /etc/cron.weekly are configured" \
  || fail "Ensure permissions on /etc/cron.weekly are configured"

############################################################
# 6 Ensure permissions on /etc/cron.monthly are configured
############################################################
stat -Lc "%a %u %g" /etc/cron.monthly 2>/dev/null | grep -q "^700 0 0" \
  && pass "Ensure permissions on /etc/cron.monthly are configured" \
  || fail "Ensure permissions on /etc/cron.monthly are configured"

############################################################
# 7 Ensure permissions on /etc/cron.d are configured
############################################################
stat -Lc "%a %u %g" /etc/cron.d 2>/dev/null | grep -q "^700 0 0" \
  && pass "Ensure permissions on /etc/cron.d are configured" \
  || fail "Ensure permissions on /etc/cron.d are configured"

############################################################
# 8 Ensure at/cron is restricted to authorized users
############################################################
if [ -f /etc/cron.allow ] || [ -f /etc/at.allow ]; then
    pass "Ensure at/cron is restricted to authorized users"
else
    fail "Ensure at/cron is restricted to authorized users"
fi
############################################################
# Ensure permissions on /etc/ssh/sshd_config are configured
############################################################
stat -Lc "%a %u %g" /etc/ssh/sshd_config 2>/dev/null | grep -q "^600 0 0" \
  && pass "Ensure permissions on /etc/ssh/sshd_config are configured" \
  || fail "Ensure permissions on /etc/ssh/sshd_config are configured"

############################################################
# Ensure SSH access is limited
############################################################
sshd -T 2>/dev/null | grep -Eq "^(allowusers|allowgroups|denyusers|denygroups)" \
  && pass "Ensure SSH access is limited" \
  || fail "Ensure SSH access is limited"

############################################################
# Ensure SSH LogLevel is appropriate
############################################################
sshd -T 2>/dev/null | grep -Eq "^loglevel (INFO|VERBOSE)" \
  && pass "Ensure SSH LogLevel is appropriate" \
  || fail "Ensure SSH LogLevel is appropriate"

############################################################
# Disable SSH X11 Forwarding
############################################################
sshd -T 2>/dev/null | grep -q "^x11forwarding no" \
  && pass "Disable SSH X11 Forwarding" \
  || fail "Disable SSH X11 Forwarding"

############################################################
# Ensure SSH MaxAuthTries is set to 4 or less
############################################################
sshd -T 2>/dev/null | awk '/maxauthtries/ {exit ($2<=4?0:1)}' \
  && pass "Ensure SSH MaxAuthTries is set to 4 or less" \
  || fail "Ensure SSH MaxAuthTries is set to 4 or less"

############################################################
# Ensure SSH IgnoreRhosts is enabled
############################################################
sshd -T 2>/dev/null | grep -q "^ignorerhosts yes" \
  && pass "Ensure SSH IgnoreRhosts is enabled" \
  || fail "Ensure SSH IgnoreRhosts is enabled"

############################################################
# Ensure SSH HostbasedAuthentication is disabled
############################################################
sshd -T 2>/dev/null | grep -q "^hostbasedauthentication no" \
  && pass "Ensure SSH HostbasedAuthentication is disabled" \
  || fail "Ensure SSH HostbasedAuthentication is disabled"

############################################################
# Ensure SSH root login is disabled
############################################################
sshd -T 2>/dev/null | grep -q "^permitrootlogin no" \
  && pass "Ensure SSH root login is disabled" \
  || fail "Ensure SSH root login is disabled"

############################################################
# Ensure SSH PermitEmptyPasswords is disabled
############################################################
sshd -T 2>/dev/null | grep -q "^permitemptypasswords no" \
  && pass "Ensure SSH PermitEmptyPasswords is disabled" \
  || fail "Ensure SSH PermitEmptyPasswords is disabled"

############################################################
# Ensure SSH PermitUserEnvironment is disabled
############################################################
sshd -T 2>/dev/null | grep -q "^permituserenvironment no" \
  && pass "Ensure SSH PermitUserEnvironment is disabled" \
  || fail "Ensure SSH PermitUserEnvironment is disabled"

############################################################
# Ensure SSH Idle Timeout Interval is configured
############################################################
sshd -T 2>/dev/null | grep -Eq "^clientaliveinterval [1-9]|^clientaliveinterval [1-9][0-9]|^clientaliveinterval [12][0-9][0-9]|^clientaliveinterval 300" \
  && pass "Ensure SSH Idle Timeout Interval is configured" \
  || fail "Ensure SSH Idle Timeout Interval is configured"

############################################################
# Ensure SSH warning banner is configured
############################################################
sshd -T 2>/dev/null | grep -q "^banner /etc/issue.net" \
  && pass "Ensure SSH warning banner is configured" \
  || fail "Ensure SSH warning banner is configured"
############################################################
# Ensure password creation requirements are configured
############################################################
grep -Eq "^minlen\s*=\s*1[4-9]|^minlen\s*=\s*[2-9][0-9]" /etc/security/pwquality.conf 2>/dev/null \
  && pass "Ensure password creation requirements are configured" \
  || fail "Ensure password creation requirements are configured"

############################################################
# Ensure lockout for failed password attempts is configured
############################################################
grep -Eq "pam_faillock.so.*deny=[1-5].*unlock_time=[9-9][0-9][0-9]" /etc/pam.d/system-auth /etc/pam.d/password-auth 2>/dev/null \
  && pass "Ensure lockout for failed password attempts is configured" \
  || fail "Ensure lockout for failed password attempts is configured"

############################################################
# Ensure password reuse is limited
############################################################
grep -q "remember=5" /etc/pam.d/system-auth 2>/dev/null \
  && pass "Ensure password reuse is limited" \
  || fail "Ensure password reuse is limited"

############################################################
# Ensure password hashing algorithm is SHA-512
############################################################
grep -Eq "pam_unix.so.*sha512" /etc/pam.d/system-auth /etc/pam.d/password-auth 2>/dev/null \
  && pass "Ensure password hashing algorithm is SHA-512" \
  || fail "Ensure password hashing algorithm is SHA-512"

############################################################
# Set Password Expiration Days
############################################################
grep -q "^PASS_MAX_DAYS 45" /etc/login.defs 2>/dev/null \
  && pass "Set Password Expiration Days" \
  || fail "Set Password Expiration Days"

############################################################
# Ensure minimum days between password changes is 7 or more
############################################################
grep -Eq "^PASS_MIN_DAYS\s+[7-9]|^PASS_MIN_DAYS\s+[1-9][0-9]" /etc/login.defs 2>/dev/null \
  && pass "Ensure minimum days between password changes is 7 or more" \
  || fail "Ensure minimum days between password changes is 7 or more"

############################################################
# Ensure password expiration warning days is 7 or more
############################################################
grep -Eq "^PASS_WARN_AGE\s+[7-9]|^PASS_WARN_AGE\s+[1-9][0-9]" /etc/login.defs 2>/dev/null \
  && pass "Ensure password expiration warning days is 7 or more" \
  || fail "Ensure password expiration warning days is 7 or more"

############################################################
# Ensure system accounts are secured
############################################################
awk -F: '($1!="root" && $3<1000 && $7!~/(nologin|false)/)' /etc/passwd | grep -q . \
  && fail "Ensure system accounts are secured" \
  || pass "Ensure system accounts are secured"

############################################################
# Ensure default user umask is 027 or more restrictive
############################################################
grep -Eq "umask\s+0(27|77)" /etc/bashrc /etc/profile /etc/profile.d/*.sh 2>/dev/null \
  && pass "Ensure default user umask is 027 or more restrictive" \
  || fail "Ensure default user umask is 027 or more restrictive"


echo
echo "=================================================="
echo "SECTION F - SYSTEM FILE PERMISSIONS"
echo "=================================================="

# 1 Ensure permissions on /etc/passwd are configured
if [[ "$(stat -c '%a %u %g' /etc/passwd)" == "644 0 0" ]]; then
    echo "[PASS] Ensure permissions on /etc/passwd are configured"
    ((PASS++))
else
    echo "[FAIL] Ensure permissions on /etc/passwd are configured"
    ((FAIL++))
fi

# 2 Ensure permissions on /etc/shadow are configured
mode=$(stat -c '%a' /etc/shadow)
uid=$(stat -c '%u' /etc/shadow)
if [[ "$uid" -eq 0 && "$mode" -le 640 ]]; then
    echo "[PASS] Ensure permissions on /etc/shadow are configured"
    ((PASS++))
else
    echo "[FAIL] Ensure permissions on /etc/shadow are configured"
    ((FAIL++))
fi

# 3 Ensure permissions on /etc/group are configured
if [[ "$(stat -c '%a %u %g' /etc/group)" == "644 0 0" ]]; then
    echo "[PASS] Ensure permissions on /etc/group are configured"
    ((PASS++))
else
    echo "[FAIL] Ensure permissions on /etc/group are configured"
    ((FAIL++))
fi

# 4 Ensure permissions on /etc/gshadow are configured
mode=$(stat -c '%a' /etc/gshadow)
uid=$(stat -c '%u' /etc/gshadow)
if [[ "$uid" -eq 0 && "$mode" -le 640 ]]; then
    echo "[PASS] Ensure permissions on /etc/gshadow are configured"
    ((PASS++))
else
    echo "[FAIL] Ensure permissions on /etc/gshadow are configured"
    ((FAIL++))
fi

# 5 Ensure permissions on /etc/passwd- are configured
mode=$(stat -c '%a' /etc/passwd-)
uid=$(stat -c '%u' /etc/passwd-)
if [[ "$uid" -eq 0 && "$mode" -le 600 ]]; then
    echo "[PASS] Ensure permissions on /etc/passwd- are configured"
    ((PASS++))
else
    echo "[FAIL] Ensure permissions on /etc/passwd- are configured"
    ((FAIL++))
fi

# 6 Ensure permissions on /etc/shadow- are configured
mode=$(stat -c '%a' /etc/shadow-)
uid=$(stat -c '%u' /etc/shadow-)
if [[ "$uid" -eq 0 && "$mode" -le 640 ]]; then
    echo "[PASS] Ensure permissions on /etc/shadow- are configured"
    ((PASS++))
else
    echo "[FAIL] Ensure permissions on /etc/shadow- are configured"
    ((FAIL++))
fi

# 7 Ensure permissions on /etc/group- are configured
mode=$(stat -c '%a' /etc/group-)
uid=$(stat -c '%u' /etc/group-)
if [[ "$uid" -eq 0 && "$mode" -le 644 ]]; then
    echo "[PASS] Ensure permissions on /etc/group- are configured"
    ((PASS++))
else
    echo "[FAIL] Ensure permissions on /etc/group- are configured"
    ((FAIL++))
fi

# 8 Ensure permissions on /etc/gshadow- are configured
mode=$(stat -c '%a' /etc/gshadow-)
uid=$(stat -c '%u' /etc/gshadow-)
if [[ "$uid" -eq 0 && "$mode" -le 640 ]]; then
    echo "[PASS] Ensure permissions on /etc/gshadow- are configured"
    ((PASS++))
else
    echo "[FAIL] Ensure permissions on /etc/gshadow- are configured"
    ((FAIL++))
fi

# 9 Ensure password fields are not empty
if [[ -z "$(awk -F: '($2 == "") {print}' /etc/shadow)" ]]; then
    echo "[PASS] Ensure password fields are not empty"
    ((PASS++))
else
    echo "[FAIL] Ensure password fields are not empty"
    ((FAIL++))
fi

# 10 Ensure root PATH Integrity
path_issue=0
for x in $(echo $PATH | tr ":" " "); do
    if [[ "$x" == "." ]]; then path_issue=1; fi
    if [[ -d "$x" ]]; then
        owner=$(stat -c '%U' "$x")
        perms=$(stat -c '%A' "$x")
        [[ "$owner" != "root" ]] && path_issue=1
        [[ "${perms:5:1}" != "-" ]] && path_issue=1
        [[ "${perms:8:1}" != "-" ]] && path_issue=1
    fi
done
if [[ "$path_issue" -eq 0 ]]; then
    echo "[PASS] Ensure root PATH Integrity"
    ((PASS++))
else
    echo "[FAIL] Ensure root PATH Integrity"
    ((FAIL++))
fi

# 11 Ensure root is the only UID 0 account
if [[ "$(awk -F: '($3 == 0)' /etc/passwd | wc -l)" -eq 1 ]]; then
    echo "[PASS] Ensure root is the only UID 0 account"
    ((PASS++))
else
    echo "[FAIL] Ensure root is the only UID 0 account"
    ((FAIL++))
fi

# 12 Ensure users' home directories permissions are 750 or more restrictive
perm_issue=0
for dir in $(awk -F: '($3 >= 1000 && $7 !~ /(nologin|false)/) {print $6}' /etc/passwd); do
    if [[ -d "$dir" ]]; then
        mode=$(stat -c '%a' "$dir")
        [[ "$mode" -gt 750 ]] && perm_issue=1
    fi
done
if [[ "$perm_issue" -eq 0 ]]; then
    echo "[PASS] Ensure users' home directories permissions are 750 or more restrictive"
    ((PASS++))
else
    echo "[FAIL] Ensure users' home directories permissions are 750 or more restrictive"
    ((FAIL++))
fi

# 13 Ensure users own their home directories
owner_issue=0
while IFS=: read -r user _ uid _ _ home shell; do
    if [[ "$uid" -ge 1000 && "$shell" != *nologin && "$shell" != *false ]]; then
        [[ -d "$home" && "$(stat -c '%U' "$home")" != "$user" ]] && owner_issue=1
    fi
done < /etc/passwd
if [[ "$owner_issue" -eq 0 ]]; then
    echo "[PASS] Ensure users own their home directories"
    ((PASS++))
else
    echo "[FAIL] Ensure users own their home directories"
    ((FAIL++))
fi

# 14 Ensure no duplicate UIDs exist
if [[ -z "$(cut -d: -f3 /etc/passwd | sort | uniq -d)" ]]; then
    echo "[PASS] Ensure no duplicate UIDs exist"
    ((PASS++))
else
    echo "[FAIL] Ensure no duplicate UIDs exist"
    ((FAIL++))
fi

# 15 Ensure no duplicate GIDs exist
if [[ -z "$(cut -d: -f3 /etc/group | sort | uniq -d)" ]]; then
    echo "[PASS] Ensure no duplicate GIDs exist"
    ((PASS++))
else
    echo "[FAIL] Ensure no duplicate GIDs exist"
    ((FAIL++))
fi

# 16 Ensure all users' home directories exist
home_issue=0
while IFS=: read -r user _ uid _ _ home shell; do
    if [[ "$uid" -ge 1000 && "$shell" != *nologin && "$shell" != *false ]]; then
        [[ ! -d "$home" ]] && home_issue=1
    fi
done < /etc/passwd
if [[ "$home_issue" -eq 0 ]]; then
    echo "[PASS] Ensure all users' home directories exist"
    ((PASS++))
else
    echo "[FAIL] Ensure all users' home directories exist"
    ((FAIL++))
fi


echo
echo "=================================================="
echo "FINAL AUDIT SUMMARY"
echo "=================================================="

# Ensure counters exist (in case earlier sections didn't initialize them)
PASS=${PASS:-0}
FAIL=${FAIL:-0}
MANUAL=${MANUAL:-0}

TOTAL=$((PASS + FAIL + MANUAL))

if [ "$TOTAL" -gt 0 ]; then
    COMPLIANCE=$(awk "BEGIN {printf \"%.2f\", ($PASS/$TOTAL)*100}")
else
    COMPLIANCE="0.00"
fi

echo "Total Checks      : $TOTAL"
echo "Passed Checks     : $PASS"
echo "Failed Checks     : $FAIL"
echo "Manual Checks     : $MANUAL"
echo "Compliance Score  : $COMPLIANCE %"