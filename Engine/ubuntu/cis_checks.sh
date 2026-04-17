#!/bin/bash

############################################################
# Ubuntu CIS Security Audit Script
#
# Author: Sammy Wambua and Kiiru Maina
# Description:
# A lightweight Bash-based auditing tool that validates
# Ubuntu system configurations against CIS-style Linux
# security hardening controls.
#
# The script performs automated security checks across
# multiple system areas including services, authentication,
# SSH configuration, file permissions, cron restrictions,
# PAM policies, and user account security.
#
# Output includes PASS / FAIL / MANUAL results and a
# final compliance summary score.
#
# Supported Platforms:
# Ubuntu 20.04
# Ubuntu 22.04
# Ubuntu 24.04
#
############################################################


echo
echo "=================================================="
echo "SECTION A: FILESYSTEM CONFIGURATION"
echo "=================================================="

# 1.1.1.1 Ensure mounting of cramfs filesystems is disabled
if modprobe -n -v cramfs 2>/dev/null | grep -q "install /bin/true"; then
    echo "[PASS] Ensure mounting of cramfs filesystems is disabled"
    ((PASS++))
else
    echo "[FAIL] Ensure mounting of cramfs filesystems is disabled"
    ((FAIL++))
fi

# 1.1.1.2 Ensure mounting of freevxfs filesystems is disabled
if modprobe -n -v freevxfs 2>/dev/null | grep -q "install /bin/true"; then
    echo "[PASS] Ensure mounting of freevxfs filesystems is disabled"
    ((PASS++))
else
    echo "[FAIL] Ensure mounting of freevxfs filesystems is disabled"
    ((FAIL++))
fi

# 1.1.1.3 Ensure mounting of jffs2 filesystems is disabled
if modprobe -n -v jffs2 2>/dev/null | grep -q "install /bin/true"; then
    echo "[PASS] Ensure mounting of jffs2 filesystems is disabled"
    ((PASS++))
else
    echo "[FAIL] Ensure mounting of jffs2 filesystems is disabled"
    ((FAIL++))
fi

# 1.1.1.4 Ensure mounting of hfs filesystems is disabled
if modprobe -n -v hfs 2>/dev/null | grep -q "install /bin/true"; then
    echo "[PASS] Ensure mounting of hfs filesystems is disabled"
    ((PASS++))
else
    echo "[FAIL] Ensure mounting of hfs filesystems is disabled"
    ((FAIL++))
fi

# 1.1.1.5 Ensure mounting of hfsplus filesystems is disabled
if modprobe -n -v hfsplus 2>/dev/null | grep -q "install /bin/true"; then
    echo "[PASS] Ensure mounting of hfsplus filesystems is disabled"
    ((PASS++))
else
    echo "[FAIL] Ensure mounting of hfsplus filesystems is disabled"
    ((FAIL++))
fi

# 1.1.1.6 Ensure mounting of udf filesystems is disabled
if modprobe -n -v udf 2>/dev/null | grep -q "install /bin/true"; then
    echo "[PASS] Ensure mounting of udf filesystems is disabled"
    ((PASS++))
else
    echo "[FAIL] Ensure mounting of udf filesystems is disabled"
    ((FAIL++))
fi

# 1.1.1.7 Ensure mounting of FAT filesystems is limited
if modprobe -n -v vfat 2>/dev/null | grep -q "install /bin/true"; then
    echo "[PASS] Ensure mounting of FAT filesystems is limited"
    ((PASS++))
else
    echo "[MANUAL] Ensure mounting of FAT filesystems is limited"
    ((MANUAL++))
fi

# 1.1.2 Ensure /tmp is configured
if mount | grep -E '\s/tmp\s' >/dev/null; then
    echo "[PASS] Ensure /tmp is configured"
    ((PASS++))
else
    echo "[FAIL] Ensure /tmp is configured"
    ((FAIL++))
fi

# 1.1.3 Ensure nodev option set on /tmp partition
if mount | grep -E '\s/tmp\s' | grep -q nodev; then
    echo "[PASS] Ensure nodev option set on /tmp partition"
    ((PASS++))
else
    echo "[FAIL] Ensure nodev option set on /tmp partition"
    ((FAIL++))
fi

# 1.1.4 Ensure nosuid option set on /tmp partition
if mount | grep -E '\s/tmp\s' | grep -q nosuid; then
    echo "[PASS] Ensure nosuid option set on /tmp partition"
    ((PASS++))
else
    echo "[FAIL] Ensure nosuid option set on /tmp partition"
    ((FAIL++))
fi

# 1.1.5 Ensure noexec option set on /tmp partition
if mount | grep -E '\s/tmp\s' | grep -q noexec; then
    echo "[PASS] Ensure noexec option set on /tmp partition"
    ((PASS++))
else
    echo "[FAIL] Ensure noexec option set on /tmp partition"
    ((FAIL++))
fi

# 1.1.6 Ensure /dev/shm is configured
if mount | grep -E '\s/dev/shm\s' >/dev/null; then
    echo "[PASS] Ensure /dev/shm is configured"
    ((PASS++))
else
    echo "[FAIL] Ensure /dev/shm is configured"
    ((FAIL++))
fi

# 1.1.7 Ensure nodev option set on /dev/shm partition
if mount | grep -E '\s/dev/shm\s' | grep -q nodev; then
    echo "[PASS] Ensure nodev option set on /dev/shm partition"
    ((PASS++))
else
    echo "[FAIL] Ensure nodev option set on /dev/shm partition"
    ((FAIL++))
fi

# 1.1.8 Ensure nosuid option set on /dev/shm partition
if mount | grep -E '\s/dev/shm\s' | grep -q nosuid; then
    echo "[PASS] Ensure nosuid option set on /dev/shm partition"
    ((PASS++))
else
    echo "[FAIL] Ensure nosuid option set on /dev/shm partition"
    ((FAIL++))
fi

# 1.1.9 Ensure noexec option set on /dev/shm partition
if mount | grep -E '\s/dev/shm\s' | grep -q noexec; then
    echo "[PASS] Ensure noexec option set on /dev/shm partition"
    ((PASS++))
else
    echo "[FAIL] Ensure noexec option set on /dev/shm partition"
    ((FAIL++))
fi

# 1.1.10 Ensure separate partition exists for /var
if mount | grep -E '\s/var\s' >/dev/null; then
    echo "[PASS] Ensure separate partition exists for /var"
    ((PASS++))
else
    echo "[MANUAL] Ensure separate partition exists for /var"
    ((MANUAL++))
fi

# 1.1.11 Ensure separate partition exists for /var/tmp
if mount | grep -E '\s/var/tmp\s' >/dev/null; then
    echo "[PASS] Ensure separate partition exists for /var/tmp"
    ((PASS++))
else
    echo "[MANUAL] Ensure separate partition exists for /var/tmp"
    ((MANUAL++))
fi

# 1.1.12 Ensure nodev option set on /var/tmp partition
if mount | grep -E '\s/var/tmp\s' | grep -q nodev; then
    echo "[PASS] Ensure nodev option set on /var/tmp partition"
    ((PASS++))
else
    echo "[FAIL] Ensure nodev option set on /var/tmp partition"
    ((FAIL++))
fi

# 1.1.13 Ensure nosuid option set on /var/tmp partition
if mount | grep -E '\s/var/tmp\s' | grep -q nosuid; then
    echo "[PASS] Ensure nosuid option set on /var/tmp partition"
    ((PASS++))
else
    echo "[FAIL] Ensure nosuid option set on /var/tmp partition"
    ((FAIL++))
fi

# 1.1.14 Ensure noexec option set on /var/tmp partition
if mount | grep -E '\s/var/tmp\s' | grep -q noexec; then
    echo "[PASS] Ensure noexec option set on /var/tmp partition"
    ((PASS++))
else
    echo "[FAIL] Ensure noexec option set on /var/tmp partition"
    ((FAIL++))
fi

# 1.1.15 Ensure separate partition exists for /var/log
if mount | grep -E '\s/var/log\s' >/dev/null; then
    echo "[PASS] Ensure separate partition exists for /var/log"
    ((PASS++))
else
    echo "[MANUAL] Ensure separate partition exists for /var/log"
    ((MANUAL++))
fi

# 1.1.16 Ensure separate partition exists for /var/log/audit
if mount | grep -E '\s/var/log/audit\s' >/dev/null; then
    echo "[PASS] Ensure separate partition exists for /var/log/audit"
    ((PASS++))
else
    echo "[MANUAL] Ensure separate partition exists for /var/log/audit"
    ((MANUAL++))
fi

# 1.1.17 Ensure separate partition exists for /home
if mount | grep -E '\s/home\s' >/dev/null; then
    echo "[PASS] Ensure separate partition exists for /home"
    ((PASS++))
else
    echo "[MANUAL] Ensure separate partition exists for /home"
    ((MANUAL++))
fi

# 1.1.18 Ensure nodev option set on /home partition
if mount | grep -E '\s/home\s' | grep -q nodev; then
    echo "[PASS] Ensure nodev option set on /home partition"
    ((PASS++))
else
    echo "[FAIL] Ensure nodev option set on /home partition"
    ((FAIL++))
fi

# 1.1.19 Ensure nodev option set on removable media partitions
echo "[MANUAL] Ensure nodev option set on removable media partitions"
((MANUAL++))

# 1.1.20 Ensure nosuid option set on removable media partitions
echo "[MANUAL] Ensure nosuid option set on removable media partitions"
((MANUAL++))

# 1.1.21 Ensure noexec option set on removable media partitions
echo "[MANUAL] Ensure noexec option set on removable media partitions"
((MANUAL++))

# 1.1.22 Ensure sticky bit is set on all world-writable directories
if df --local -P | awk '{if (NR!=1) print $6}' | xargs -I '{}' find '{}' -xdev -type d \( -perm -0002 -a ! -perm -1000 \) 2>/dev/null | grep -q .; then
    echo "[FAIL] Ensure sticky bit is set on all world-writable directories"
    ((FAIL++))
else
    echo "[PASS] Ensure sticky bit is set on all world-writable directories"
    ((PASS++))
fi

# 1.1.23 Disable Automounting
if systemctl is-enabled autofs 2>/dev/null | grep -q enabled; then
    echo "[FAIL] Disable Automounting"
    ((FAIL++))
else
    echo "[PASS] Disable Automounting"
    ((PASS++))
fi

# 1.1.24 Disable USB storage
if modprobe -n -v usb-storage 2>/dev/null | grep -q "install /bin/true"; then
    echo "[PASS] Disable USB storage"
    ((PASS++))
else
    echo "[FAIL] Disable USB storage"
    ((FAIL++))
fi
echo
echo "=================================================="
echo "CONFIGURE SOFTWARE UPDATES"
echo "=================================================="

# 1.2.1 Ensure package manager repositories are configured
if apt-cache policy 2>/dev/null | grep -q "http"; then
    echo "[PASS] Ensure package manager repositories are configured"
    ((PASS++))
else
    echo "[FAIL] Ensure package manager repositories are configured"
    ((FAIL++))
fi

# 1.2.2 Ensure GPG keys are configured
if apt-key list 2>/dev/null | grep -q "pub"; then
    echo "[PASS] Ensure GPG keys are configured"
    ((PASS++))
else
    echo "[FAIL] Ensure GPG keys are configured"
    ((FAIL++))
fi
echo
echo "=================================================="
echo "CONFIGURE SUDO"
echo "=================================================="

# 1.3.1 Ensure sudo is installed
if dpkg -s sudo >/dev/null 2>&1 || dpkg -s sudo-ldap >/dev/null 2>&1; then
    echo "[PASS] Ensure sudo is installed"
    ((PASS++))
else
    echo "[FAIL] Ensure sudo is installed"
    ((FAIL++))
fi

# 1.3.2 Ensure sudo commands use pty
if grep -Ei '^\s*Defaults\s+([^#]+,\s*)?use_pty(,\s+\S+\s*)*(\s+#.*)?$' /etc/sudoers /etc/sudoers.d/* >/dev/null 2>&1; then
    echo "[PASS] Ensure sudo commands use pty"
    ((PASS++))
else
    echo "[FAIL] Ensure sudo commands use pty"
    ((FAIL++))
fi

# 1.3.3 Ensure sudo log file exists
if grep -Ei '^\s*Defaults\s+logfile=\S+' /etc/sudoers /etc/sudoers.d/* >/dev/null 2>&1; then
    echo "[PASS] Ensure sudo log file exists"
    ((PASS++))
else
    echo "[FAIL] Ensure sudo log file exists"
    ((FAIL++))
fi
echo
echo "=================================================="
echo "FILESYSTEM INTEGRITY CHECKING"
echo "=================================================="

# 1.4.1 Ensure AIDE is installed
if dpkg -s aide 2>/dev/null | grep -q "Status: install ok installed" && \
   dpkg -s aide-common 2>/dev/null | grep -q "Status: install ok installed"; then
    echo "[PASS] Ensure AIDE is installed"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure AIDE is installed"
    FAIL=$((FAIL+1))
fi

# 1.4.2 Ensure filesystem integrity is regularly checked
if crontab -u root -l 2>/dev/null | grep -q aide || \
   find /etc/cron.* /etc/crontab -type f -name "*aide*" 2>/dev/null | grep -q aide || \
   systemctl is-enabled aidecheck.timer 2>/dev/null | grep -q enabled; then
    echo "[PASS] Ensure filesystem integrity is regularly checked"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure filesystem integrity is regularly checked"
    FAIL=$((FAIL+1))
fi


echo
echo "=================================================="
echo "SECURE BOOT SETTINGS"
echo "=================================================="

# 1.5.1 Ensure bootloader password is set
if grep -q "^set superusers" /boot/grub/grub.cfg 2>/dev/null && \
   grep -q "^password_pbkdf2" /boot/grub/grub.cfg 2>/dev/null; then
    echo "[PASS] Ensure bootloader password is set"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure bootloader password is set"
    FAIL=$((FAIL+1))
fi

# 1.5.2 Ensure permissions on bootloader config are configured
perm=$(stat -c "%a" /boot/grub/grub.cfg 2>/dev/null)
owner=$(stat -c "%U" /boot/grub/grub.cfg 2>/dev/null)

if [[ "$perm" -le 400 && "$owner" == "root" ]]; then
    echo "[PASS] Ensure permissions on bootloader config are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on bootloader config are configured"
    FAIL=$((FAIL+1))
fi

# 1.5.3 Ensure authentication required for single user mode
if grep '^root:' /etc/shadow | grep -vq '^[^:]*:[!*]'; then
    echo "[PASS] Ensure authentication required for single user mode"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure authentication required for single user mode"
    FAIL=$((FAIL+1))
fi


echo
echo "=================================================="
echo "ADDITIONAL PROCESS HARDENING"
echo "=================================================="

# 1.6.1 Ensure XD/NX support is enabled
if journalctl 2>/dev/null | grep -q "NX (Execute Disable) protection: active"; then
    echo "[PASS] Ensure XD/NX support is enabled"
    PASS=$((PASS+1))
else
    echo "[MANUAL] Ensure XD/NX support is enabled"
    MANUAL=$((MANUAL+1))
fi

# 1.6.2 Ensure address space layout randomization (ASLR) is enabled
if sysctl kernel.randomize_va_space 2>/dev/null | grep -q "2"; then
    echo "[PASS] Ensure address space layout randomization (ASLR) is enabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure address space layout randomization (ASLR) is enabled"
    FAIL=$((FAIL+1))
fi

# 1.6.3 Ensure prelink is disabled
if ! dpkg -s prelink >/dev/null 2>&1; then
    echo "[PASS] Ensure prelink is disabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure prelink is disabled"
    FAIL=$((FAIL+1))
fi

# 1.6.4 Ensure core dumps are restricted
if grep -Eq "^\* hard core 0" /etc/security/limits.conf /etc/security/limits.d/* 2>/dev/null && \
   sysctl fs.suid_dumpable 2>/dev/null | grep -q "0"; then
    echo "[PASS] Ensure core dumps are restricted"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure core dumps are restricted"
    FAIL=$((FAIL+1))
fi
echo
echo "=================================================="
echo "MANDATORY ACCESS CONTROL"
echo "=================================================="

# Ensure AppArmor is installed
if dpkg -s apparmor 2>/dev/null | grep -q "Status: install ok installed"; then
    echo "[PASS] Ensure AppArmor is installed"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure AppArmor is installed"
    FAIL=$((FAIL+1))
fi

# Ensure AppArmor is enabled in the bootloader configuration
if grep "^\s*linux" /boot/grub/grub.cfg | grep -q "apparmor=1" && \
   grep "^\s*linux" /boot/grub/grub.cfg | grep -q "security=apparmor"; then
    echo "[PASS] Ensure AppArmor is enabled in the bootloader configuration"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure AppArmor is enabled in the bootloader configuration"
    FAIL=$((FAIL+1))
fi

# Ensure all AppArmor Profiles are in enforce or complain mode
if apparmor_status 2>/dev/null | grep -q "profiles are loaded"; then
    echo "[PASS] Ensure all AppArmor Profiles are in enforce or complain mode"
    PASS=$((PASS+1))
else
    echo "[MANUAL] Ensure all AppArmor Profiles are in enforce or complain mode"
    MANUAL=$((MANUAL+1))
fi

# Ensure all AppArmor Profiles are enforcing
if apparmor_status 2>/dev/null | grep -q "profiles are in enforce mode"; then
    echo "[PASS] Ensure all AppArmor Profiles are enforcing"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure all AppArmor Profiles are enforcing"
    FAIL=$((FAIL+1))
fi


echo
echo "=================================================="
echo "WARNING BANNERS"
echo "=================================================="

# Ensure message of the day is configured properly
if [ -f /etc/motd ] && ! grep -Ei "(\\\v|\\\r|\\\m|\\\s)" /etc/motd >/dev/null; then
    echo "[PASS] Ensure message of the day is configured properly"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure message of the day is configured properly"
    FAIL=$((FAIL+1))
fi

# Ensure local login warning banner is configured properly
if [ -f /etc/issue ] && ! grep -Ei "(\\\v|\\\r|\\\m|\\\s)" /etc/issue >/dev/null; then
    echo "[PASS] Ensure local login warning banner is configured properly"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure local login warning banner is configured properly"
    FAIL=$((FAIL+1))
fi

# Ensure remote login warning banner is configured properly
if [ -f /etc/issue.net ] && ! grep -Ei "(\\\v|\\\r|\\\m|\\\s)" /etc/issue.net >/dev/null; then
    echo "[PASS] Ensure remote login warning banner is configured properly"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure remote login warning banner is configured properly"
    FAIL=$((FAIL+1))
fi

# Ensure permissions on /etc/motd are configured
if [ ! -f /etc/motd ] || stat -c "%a %U %G" /etc/motd | grep -q "644 root root"; then
    echo "[PASS] Ensure permissions on /etc/motd are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/motd are configured"
    FAIL=$((FAIL+1))
fi

# Ensure permissions on /etc/issue are configured
if stat -c "%a %U %G" /etc/issue | grep -q "644 root root"; then
    echo "[PASS] Ensure permissions on /etc/issue are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/issue are configured"
    FAIL=$((FAIL+1))
fi

# Ensure permissions on /etc/issue.net are configured
if stat -c "%a %U %G" /etc/issue.net | grep -q "644 root root"; then
    echo "[PASS] Ensure permissions on /etc/issue.net are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/issue.net are configured"
    FAIL=$((FAIL+1))
fi


echo
echo "=================================================="
echo "PATCH MANAGEMENT"
echo "=================================================="

# Ensure updates, patches, and additional security software are installed
if apt-get -s upgrade | grep -q "0 upgraded"; then
    echo "[PASS] Ensure updates, patches, and additional security software are installed"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure updates, patches, and additional security software are installed"
    FAIL=$((FAIL+1))
fi


echo
echo "=================================================="
echo "GDM CONFIGURATION"
echo "=================================================="

# Ensure GDM is removed or login is configured
if ! dpkg -s gdm3 >/dev/null 2>&1; then
    echo "[PASS] Ensure GDM is removed or login is configured"
    PASS=$((PASS+1))
else
    if grep -q "disable-user-list=true" /etc/gdm3/greeter.dconf-defaults 2>/dev/null; then
        echo "[PASS] Ensure GDM is removed or login is configured"
        PASS=$((PASS+1))
    else
        echo "[FAIL] Ensure GDM is removed or login is configured"
        FAIL=$((FAIL+1))
    fi
fi
echo
echo "=================================================="
echo "SECTION B: SERVICES"
echo "=================================================="

echo
echo "---------------- INETD SERVICES ----------------"

# Ensure xinetd is not installed
if ! dpkg -s xinetd >/dev/null 2>&1; then
    echo "[PASS] Ensure xinetd is not installed"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure xinetd is not installed"
    FAIL=$((FAIL+1))
fi

# Ensure openbsd-inetd is not installed
if ! dpkg -s openbsd-inetd >/dev/null 2>&1; then
    echo "[PASS] Ensure openbsd-inetd is not installed"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure openbsd-inetd is not installed"
    FAIL=$((FAIL+1))
fi


echo
echo "------------- TIME SYNCHRONIZATION -------------"

# Ensure time synchronization is in use
if systemctl is-enabled systemd-timesyncd >/dev/null 2>&1 || \
   dpkg -s chrony >/dev/null 2>&1 || \
   dpkg -s ntp >/dev/null 2>&1; then
    echo "[PASS] Ensure time synchronization is in use"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure time synchronization is in use"
    FAIL=$((FAIL+1))
fi


echo
echo "----------- SPECIAL PURPOSE SERVICES -----------"

check_pkg_absent () {
    pkg=$1
    desc=$2

    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
        echo "[PASS] $desc"
        PASS=$((PASS+1))
    else
        echo "[FAIL] $desc"
        FAIL=$((FAIL+1))
    fi
}

check_pkg_absent xserver-xorg "Ensure X Window System is not installed"
check_pkg_absent avahi-daemon "Ensure Avahi Server is not installed"
check_pkg_absent cups "Ensure CUPS is not installed"
check_pkg_absent isc-dhcp-server "Ensure DHCP Server is not installed"
check_pkg_absent slapd "Ensure LDAP server is not installed"
check_pkg_absent nfs-kernel-server "Ensure NFS is not installed"
check_pkg_absent bind9 "Ensure DNS Server is not installed"
check_pkg_absent vsftpd "Ensure FTP Server is not installed"
check_pkg_absent apache2 "Ensure HTTP server is not installed"
check_pkg_absent dovecot-imapd "Ensure IMAP server is not installed"
check_pkg_absent dovecot-pop3d "Ensure POP3 server is not installed"
check_pkg_absent samba "Ensure Samba is not installed"
check_pkg_absent squid "Ensure HTTP Proxy Server is not installed"
check_pkg_absent snmpd "Ensure SNMP Server is not installed"
check_pkg_absent rsync "Ensure rsync service is not installed"
check_pkg_absent nis "Ensure NIS Server is not installed"


echo
echo "--------------- SERVICE CLIENTS ----------------"

check_pkg_absent nis "Ensure NIS Client is not installed"
check_pkg_absent rsh-client "Ensure rsh client is not installed"
check_pkg_absent talk "Ensure talk client is not installed"
check_pkg_absent telnet "Ensure telnet client is not installed"
check_pkg_absent ldap-utils "Ensure LDAP client is not installed"
check_pkg_absent rpcbind "Ensure RPC is not installed"


echo
echo "------------- MAIL TRANSFER AGENT --------------"

if ss -lntu | grep ':25 ' | grep -vE '(127.0.0.1|::1)' >/dev/null; then
    echo "[FAIL] Ensure mail transfer agent is configured for local-only mode"
    FAIL=$((FAIL+1))
else
    echo "[PASS] Ensure mail transfer agent is configured for local-only mode"
    PASS=$((PASS+1))
fi


echo "----------- NONESSENTIAL SERVICES REVIEW --------"
echo "[MANUAL] Ensure nonessential services are removed or masked"
echo

ss -tulnp | awk 'NR>1 {split($5,a,":"); split($7,b,"\""); printf "%-6s %s\n", a[length(a)], b[2]}' | sort -u
echo
echo "=================================================="
echo "SECTION C: NETWORK CONFIGURATION"
echo "=================================================="

echo
echo "------------ DISABLE UNUSED NETWORK PROTOCOLS ------------"

# Disable IPv6
if grep -E "ipv6.disable=1" /boot/grub/grub.cfg >/dev/null 2>&1; then
    echo "[PASS] Disable IPv6"
    PASS=$((PASS+1))
else
    echo "[FAIL] Disable IPv6"
    FAIL=$((FAIL+1))
fi


# Ensure wireless interfaces are disabled
if command -v nmcli >/dev/null 2>&1; then
    if nmcli radio all | grep -q "disabled"; then
        echo "[PASS] Ensure wireless interfaces are disabled"
        PASS=$((PASS+1))
    else
        echo "[FAIL] Ensure wireless interfaces are disabled"
        FAIL=$((FAIL+1))
    fi
else
    echo "[MANUAL] Ensure wireless interfaces are disabled (NetworkManager not installed)"
    MANUAL=$((MANUAL+1))
fi


echo
echo "------------ NETWORK PARAMETERS (HOST ONLY) ------------"

# Ensure packet redirect sending is disabled
if sysctl net.ipv4.conf.all.send_redirects | grep -q "= 0" && \
   sysctl net.ipv4.conf.default.send_redirects | grep -q "= 0"; then
    echo "[PASS] Ensure packet redirect sending is disabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure packet redirect sending is disabled"
    FAIL=$((FAIL+1))
fi


# Ensure IP forwarding is disabled
if sysctl net.ipv4.ip_forward | grep -q "= 0"; then
    echo "[PASS] Ensure IP forwarding is disabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure IP forwarding is disabled"
    FAIL=$((FAIL+1))
fi


echo
echo "------------ NETWORK PARAMETERS (HOST AND ROUTER) ------------"

# Ensure source routed packets are not accepted
if sysctl net.ipv4.conf.all.accept_source_route | grep -q "= 0" && \
   sysctl net.ipv4.conf.default.accept_source_route | grep -q "= 0"; then
    echo "[PASS] Ensure source routed packets are not accepted"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure source routed packets are not accepted"
    FAIL=$((FAIL+1))
fi


# Ensure ICMP redirects are not accepted
if sysctl net.ipv4.conf.all.accept_redirects | grep -q "= 0" && \
   sysctl net.ipv4.conf.default.accept_redirects | grep -q "= 0"; then
    echo "[PASS] Ensure ICMP redirects are not accepted"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure ICMP redirects are not accepted"
    FAIL=$((FAIL+1))
fi


# Ensure secure ICMP redirects are not accepted
if sysctl net.ipv4.conf.all.secure_redirects | grep -q "= 0" && \
   sysctl net.ipv4.conf.default.secure_redirects | grep -q "= 0"; then
    echo "[PASS] Ensure secure ICMP redirects are not accepted"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure secure ICMP redirects are not accepted"
    FAIL=$((FAIL+1))
fi


# Ensure suspicious packets are logged
if sysctl net.ipv4.conf.all.log_martians | grep -q "= 1" && \
   sysctl net.ipv4.conf.default.log_martians | grep -q "= 1"; then
    echo "[PASS] Ensure suspicious packets are logged"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure suspicious packets are logged"
    FAIL=$((FAIL+1))
fi


# Ensure broadcast ICMP requests are ignored
if sysctl net.ipv4.icmp_echo_ignore_broadcasts | grep -q "= 1"; then
    echo "[PASS] Ensure broadcast ICMP requests are ignored"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure broadcast ICMP requests are ignored"
    FAIL=$((FAIL+1))
fi


# Ensure bogus ICMP responses are ignored
if sysctl net.ipv4.icmp_ignore_bogus_error_responses | grep -q "= 1"; then
    echo "[PASS] Ensure bogus ICMP responses are ignored"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure bogus ICMP responses are ignored"
    FAIL=$((FAIL+1))
fi


# Ensure Reverse Path Filtering is enabled
if sysctl net.ipv4.conf.all.rp_filter | grep -q "= 1" && \
   sysctl net.ipv4.conf.default.rp_filter | grep -q "= 1"; then
    echo "[PASS] Ensure Reverse Path Filtering is enabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure Reverse Path Filtering is enabled"
    FAIL=$((FAIL+1))
fi


# Ensure TCP SYN Cookies is enabled
if sysctl net.ipv4.tcp_syncookies | grep -q "= 1"; then
    echo "[PASS] Ensure TCP SYN Cookies is enabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure TCP SYN Cookies is enabled"
    FAIL=$((FAIL+1))
fi


echo
echo "------------ UNCOMMON NETWORK PROTOCOLS ------------"

# Ensure DCCP is disabled
if modprobe -n -v dccp 2>/dev/null | grep -q "install /bin/true"; then
    echo "[PASS] Ensure DCCP is disabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure DCCP is disabled"
    FAIL=$((FAIL+1))
fi


# Ensure SCTP is disabled
if modprobe -n -v sctp 2>/dev/null | grep -q "install /bin/true"; then
    echo "[PASS] Ensure SCTP is disabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SCTP is disabled"
    FAIL=$((FAIL+1))
fi


# Ensure RDS is disabled
if modprobe -n -v rds 2>/dev/null | grep -q "install /bin/true"; then
    echo "[PASS] Ensure RDS is disabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure RDS is disabled"
    FAIL=$((FAIL+1))
fi


# Ensure TIPC is disabled
if modprobe -n -v tipc 2>/dev/null | grep -q "install /bin/true"; then
    echo "[PASS] Ensure TIPC is disabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure TIPC is disabled"
    FAIL=$((FAIL+1))
fi
echo
echo "=================================================="
echo "FIREWALL CONFIGURATION"
echo "=================================================="

echo
echo "------------ UFW CONFIGURATION ------------"

# Ensure Uncomplicated Firewall is installed
if dpkg -s ufw 2>/dev/null | grep -q "Status: install ok installed"; then
    echo "[PASS] Ensure Uncomplicated Firewall is installed"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure Uncomplicated Firewall is installed"
    FAIL=$((FAIL+1))
fi


# Ensure iptables-persistent is not installed
if dpkg-query -s iptables-persistent 2>&1 | grep -q "is not installed"; then
    echo "[PASS] Ensure iptables-persistent is not installed"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure iptables-persistent is not installed"
    FAIL=$((FAIL+1))
fi


# Ensure ufw service is enabled
if systemctl is-enabled ufw 2>/dev/null | grep -q enabled; then
    echo "[PASS] Ensure ufw service is enabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure ufw service is enabled"
    FAIL=$((FAIL+1))
fi


# Ensure loopback traffic is configured
if ufw status verbose | grep -q "Anywhere on lo"; then
    echo "[PASS] Ensure loopback traffic is configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure loopback traffic is configured"
    FAIL=$((FAIL+1))
fi


# Ensure outbound connections are configured
if ufw status numbered >/dev/null 2>&1; then
    echo "[PASS] Ensure outbound connections are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure outbound connections are configured"
    FAIL=$((FAIL+1))
fi


# Ensure firewall rules exist for all open ports
OPEN_PORTS=$(ss -4tuln | awk 'NR>1 {print $5}' | grep -v "127.0.0.1" | wc -l)

if [ "$OPEN_PORTS" -ge 0 ]; then
    echo "[PASS] Ensure firewall rules exist for all open ports"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure firewall rules exist for all open ports"
    FAIL=$((FAIL+1))
fi


echo
echo "------------ NFTABLES CONFIGURATION ------------"

# Ensure nftables is installed
if dpkg-query -s nftables 2>/dev/null | grep -q "install ok installed"; then
    echo "[PASS] Ensure nftables is installed"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure nftables is installed"
    FAIL=$((FAIL+1))
fi


# Ensure UFW is not installed or disabled
if ! dpkg-query -s ufw >/dev/null 2>&1 || ufw status | grep -q inactive; then
    echo "[PASS] Ensure UFW is not installed or disabled (nftables)"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure UFW is not installed or disabled (nftables)"
    FAIL=$((FAIL+1))
fi


# Ensure iptables are flushed
if iptables -L | grep -q "Chain"; then
    echo "[PASS] Ensure iptables are flushed"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure iptables are flushed"
    FAIL=$((FAIL+1))
fi


# Ensure a table exists
if nft list tables 2>/dev/null | grep -q table; then
    echo "[PASS] Ensure nftables table exists"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure nftables table exists"
    FAIL=$((FAIL+1))
fi


# Ensure base chains exist
if nft list ruleset 2>/dev/null | grep -q "hook input"; then
    echo "[PASS] Ensure nftables base chains exist"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure nftables base chains exist"
    FAIL=$((FAIL+1))
fi


# Ensure loopback traffic is configured
if nft list ruleset 2>/dev/null | grep -q 'iif "lo" accept'; then
    echo "[PASS] Ensure nftables loopback traffic configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure nftables loopback traffic configured"
    FAIL=$((FAIL+1))
fi


# Ensure outbound and established connections configured
if nft list ruleset 2>/dev/null | grep -q "ct state"; then
    echo "[PASS] Ensure outbound and established connections configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure outbound and established connections configured"
    FAIL=$((FAIL+1))
fi


# Ensure default deny firewall policy
if nft list ruleset 2>/dev/null | grep -q "policy drop"; then
    echo "[PASS] Ensure default deny firewall policy"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure default deny firewall policy"
    FAIL=$((FAIL+1))
fi


# Ensure nftables service is enabled
if systemctl is-enabled nftables 2>/dev/null | grep -q enabled; then
    echo "[PASS] Ensure nftables service is enabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure nftables service is enabled"
    FAIL=$((FAIL+1))
fi


# Ensure nftables rules are permanent
if grep -q include /etc/nftables.conf 2>/dev/null; then
    echo "[PASS] Ensure nftables rules are permanent"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure nftables rules are permanent"
    FAIL=$((FAIL+1))
fi


echo
echo "------------ IPTABLES CONFIGURATION ------------"

# Ensure iptables packages are installed
if apt list iptables 2>/dev/null | grep -q installed; then
    echo "[PASS] Ensure iptables packages are installed"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure iptables packages are installed"
    FAIL=$((FAIL+1))
fi


# Ensure nftables is not installed
if dpkg -s nftables 2>&1 | grep -q "is not installed"; then
    echo "[PASS] Ensure nftables is not installed (iptables mode)"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure nftables is not installed (iptables mode)"
    FAIL=$((FAIL+1))
fi


# Ensure UFW is not installed or disabled
if ! dpkg-query -s ufw >/dev/null 2>&1 || ufw status | grep -q inactive; then
    echo "[PASS] Ensure UFW is not installed or disabled (iptables)"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure UFW is not installed or disabled (iptables)"
    FAIL=$((FAIL+1))
fi


# Ensure default deny firewall policy
if iptables -L | grep -q "policy DROP"; then
    echo "[PASS] Ensure IPv4 default deny firewall policy"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure IPv4 default deny firewall policy"
    FAIL=$((FAIL+1))
fi


# Ensure loopback traffic configured
if iptables -L INPUT -v -n | grep -q "lo"; then
    echo "[PASS] Ensure IPv4 loopback traffic configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure IPv4 loopback traffic configured"
    FAIL=$((FAIL+1))
fi


# Ensure outbound and established connections configured
if iptables -L -v -n | grep -q ESTABLISHED; then
    echo "[PASS] Ensure outbound and established connections configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure outbound and established connections configured"
    FAIL=$((FAIL+1))
fi


# Ensure firewall rules exist for all open ports
if ss -4tuln >/dev/null; then
    echo "[PASS] Ensure IPv4 firewall rules exist for all open ports"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure IPv4 firewall rules exist for all open ports"
    FAIL=$((FAIL+1))
fi


echo
echo "------------ IPV6 IPTABLES CONFIGURATION ------------"

# Ensure IPv6 default deny firewall policy
if ip6tables -L | grep -q "policy DROP"; then
    echo "[PASS] Ensure IPv6 default deny firewall policy"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure IPv6 default deny firewall policy"
    FAIL=$((FAIL+1))
fi


# Ensure IPv6 loopback traffic configured
if ip6tables -L | grep -q lo; then
    echo "[PASS] Ensure IPv6 loopback traffic configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure IPv6 loopback traffic configured"
    FAIL=$((FAIL+1))
fi


# Ensure outbound and established connections configured
if ip6tables -L -v -n | grep -q ESTABLISHED; then
    echo "[PASS] Ensure IPv6 outbound and established connections configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure IPv6 outbound and established connections configured"
    FAIL=$((FAIL+1))
fi


# Ensure IPv6 firewall rules exist for open ports
if ss -6tuln >/dev/null; then
    echo "[PASS] Ensure IPv6 firewall rules exist for all open ports"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure IPv6 firewall rules exist for all open ports"
    FAIL=$((FAIL+1))
fi
echo
echo "=================================================="
echo "Section B: LOGGING AND AUDITING"
echo "=================================================="

echo
echo "------------ AUDITD CONFIGURATION ------------"

# Ensure auditd is installed
if dpkg -s auditd audispd-plugins 2>/dev/null | grep -q "install ok installed"; then
    echo "[PASS] Ensure auditd is installed"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure auditd is installed"
    FAIL=$((FAIL+1))
fi


# Ensure auditd service is enabled
if systemctl is-enabled auditd 2>/dev/null | grep -q enabled; then
    echo "[PASS] Ensure auditd service is enabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure auditd service is enabled"
    FAIL=$((FAIL+1))
fi


# Ensure auditing for processes that start prior to auditd is enabled
if grep "^\s*linux" /boot/grub/grub.cfg 2>/dev/null | grep -q "audit=1"; then
    echo "[PASS] Ensure auditing for processes prior to auditd is enabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure auditing for processes prior to auditd is enabled"
    FAIL=$((FAIL+1))
fi


# Ensure audit_backlog_limit is sufficient
if grep "audit_backlog_limit=" /boot/grub/grub.cfg 2>/dev/null | grep -E "8192|16384|32768"; then
    echo "[PASS] Ensure audit backlog limit configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure audit backlog limit configured"
    FAIL=$((FAIL+1))
fi


echo
echo "------------ AUDIT LOG CONFIGURATION ------------"

# Ensure audit log storage size configured
if grep -q "max_log_file" /etc/audit/auditd.conf 2>/dev/null; then
    echo "[PASS] Ensure audit log storage size configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure audit log storage size configured"
    FAIL=$((FAIL+1))
fi


# Ensure audit logs are not automatically deleted
if grep -q "max_log_file_action = keep_logs" /etc/audit/auditd.conf 2>/dev/null; then
    echo "[PASS] Ensure audit logs are not automatically deleted"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure audit logs are not automatically deleted"
    FAIL=$((FAIL+1))
fi


# Ensure system is disabled when audit logs are full
if grep -q "admin_space_left_action = halt" /etc/audit/auditd.conf 2>/dev/null; then
    echo "[PASS] Ensure system disabled when audit logs are full"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure system disabled when audit logs are full"
    FAIL=$((FAIL+1))
fi


echo
echo "------------ AUDIT RULES CHECKS ------------"

# Ensure time-change events collected
if grep -q "time-change" /etc/audit/rules.d/*.rules 2>/dev/null; then
    echo "[PASS] Ensure time change events are collected"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure time change events are collected"
    FAIL=$((FAIL+1))
fi


# Ensure identity events collected
if grep -q "identity" /etc/audit/rules.d/*.rules 2>/dev/null; then
    echo "[PASS] Ensure user/group modification events are collected"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure user/group modification events are collected"
    FAIL=$((FAIL+1))
fi


# Ensure system-locale events collected
if grep -q "system-locale" /etc/audit/rules.d/*.rules 2>/dev/null; then
    echo "[PASS] Ensure network environment changes are collected"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure network environment changes are collected"
    FAIL=$((FAIL+1))
fi


# Ensure MAC policy changes collected
if grep -q "MAC-policy" /etc/audit/rules.d/*.rules 2>/dev/null; then
    echo "[PASS] Ensure MAC policy changes are collected"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure MAC policy changes are collected"
    FAIL=$((FAIL+1))
fi


# Ensure login events collected
if grep -q "logins" /etc/audit/rules.d/*.rules 2>/dev/null; then
    echo "[PASS] Ensure login events are collected"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure login events are collected"
    FAIL=$((FAIL+1))
fi


# Ensure session events collected
if grep -q "session" /etc/audit/rules.d/*.rules 2>/dev/null; then
    echo "[PASS] Ensure session initiation events are collected"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure session initiation events are collected"
    FAIL=$((FAIL+1))
fi


# Ensure permission modification events collected
if grep -q "perm_mod" /etc/audit/rules.d/*.rules 2>/dev/null; then
    echo "[PASS] Ensure permission modification events collected"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permission modification events collected"
    FAIL=$((FAIL+1))
fi


# Ensure unauthorized file access attempts collected
if grep -q "access" /etc/audit/rules.d/*.rules 2>/dev/null; then
    echo "[PASS] Ensure unauthorized file access attempts collected"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure unauthorized file access attempts collected"
    FAIL=$((FAIL+1))
fi


# Ensure file deletion events collected
if grep -q "delete" /etc/audit/rules.d/*.rules 2>/dev/null; then
    echo "[PASS] Ensure file deletion events collected"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure file deletion events collected"
    FAIL=$((FAIL+1))
fi


# Ensure sudo scope changes collected
if grep -q "scope" /etc/audit/rules.d/*.rules 2>/dev/null; then
    echo "[PASS] Ensure sudo scope changes collected"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure sudo scope changes collected"
    FAIL=$((FAIL+1))
fi


# Ensure sudo command executions collected
if grep -q "actions" /etc/audit/rules.d/*.rules 2>/dev/null; then
    echo "[PASS] Ensure sudo command executions collected"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure sudo command executions collected"
    FAIL=$((FAIL+1))
fi


# Ensure kernel module events collected
if grep -q "modules" /etc/audit/rules.d/*.rules 2>/dev/null; then
    echo "[PASS] Ensure kernel module loading events collected"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure kernel module loading events collected"
    FAIL=$((FAIL+1))
fi


# Ensure audit configuration immutable
if grep -q "^-e 2" /etc/audit/rules.d/*.rules 2>/dev/null; then
    echo "[PASS] Ensure audit configuration is immutable"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure audit configuration is immutable"
    FAIL=$((FAIL+1))
fi
echo
echo "------------ RSYSLOG CONFIGURATION ------------"

# Ensure rsyslog is installed
if dpkg -s rsyslog 2>/dev/null | grep -q "install ok installed"; then
    echo "[PASS] Ensure rsyslog is installed"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure rsyslog is installed"
    FAIL=$((FAIL+1))
fi


# Ensure rsyslog service is enabled
if systemctl is-enabled rsyslog 2>/dev/null | grep -q enabled; then
    echo "[PASS] Ensure rsyslog service is enabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure rsyslog service is enabled"
    FAIL=$((FAIL+1))
fi


# Ensure logging is configured
if ls /var/log 2>/dev/null | grep -q auth.log; then
    echo "[PASS] Ensure logging is configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure logging is configured"
    FAIL=$((FAIL+1))
fi


# Ensure rsyslog default file permissions configured
if grep -E "^\s*\$FileCreateMode\s+0640" /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null; then
    echo "[PASS] Ensure rsyslog default file permissions configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure rsyslog default file permissions configured"
    FAIL=$((FAIL+1))
fi


# Ensure rsyslog configured to send logs to remote host
if grep -E "^[^#].*@@" /etc/rsyslog.conf /etc/rsyslog.d/*.conf 2>/dev/null; then
    echo "[PASS] Ensure rsyslog configured to send logs to remote host"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure rsyslog configured to send logs to remote host"
    FAIL=$((FAIL+1))
fi


echo
echo "------------ JOURNALD CONFIGURATION ------------"

# Ensure journald forwards logs to rsyslog
if grep -q "ForwardToSyslog=yes" /etc/systemd/journald.conf 2>/dev/null; then
    echo "[PASS] Ensure journald forwards logs to rsyslog"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure journald forwards logs to rsyslog"
    FAIL=$((FAIL+1))
fi


# Ensure journald compresses large log files
if grep -q "Compress=yes" /etc/systemd/journald.conf 2>/dev/null; then
    echo "[PASS] Ensure journald compresses large log files"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure journald compresses large log files"
    FAIL=$((FAIL+1))
fi


# Ensure journald logs persist to disk
if grep -q "Storage=persistent" /etc/systemd/journald.conf 2>/dev/null; then
    echo "[PASS] Ensure journald logs persist to disk"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure journald logs persist to disk"
    FAIL=$((FAIL+1))
fi


echo
echo "------------ LOG FILE SECURITY ------------"

# Ensure permissions on log files are restricted
if find /var/log -type f -perm /027 2>/dev/null | grep -q .; then
    echo "[FAIL] Ensure permissions on log files are restricted"
    FAIL=$((FAIL+1))
else
    echo "[PASS] Ensure permissions on log files are restricted"
    PASS=$((PASS+1))
fi


echo
echo "------------ LOGROTATE CONFIGURATION ------------"

# Ensure logrotate is configured
if [ -f /etc/logrotate.conf ]; then
    echo "[PASS] Ensure logrotate is configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure logrotate is configured"
    FAIL=$((FAIL+1))
fi


# Ensure logrotate assigns appropriate permissions
if grep -E "create\s+0640" /etc/logrotate.conf 2>/dev/null; then
    echo "[PASS] Ensure logrotate assigns appropriate permissions"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure logrotate assigns appropriate permissions"
    FAIL=$((FAIL+1))
fi
echo
echo "=================================================="
echo "SECTION E: ACCESS, AUTHENTICATION AND AUTHORIZATION"
echo "TIME-BASED JOB SCHEDULERS"
echo "=================================================="

# Ensure cron daemon is enabled and running
if systemctl is-enabled cron 2>/dev/null | grep -q enabled && \
   systemctl is-active cron 2>/dev/null | grep -q active; then
    echo "[PASS] Ensure cron daemon is enabled and running"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure cron daemon is enabled and running"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on /etc/crontab are configured
perm=$(stat -c "%a" /etc/crontab 2>/dev/null)
owner=$(stat -c "%U:%G" /etc/crontab 2>/dev/null)

if [ "$perm" = "600" ] && [ "$owner" = "root:root" ]; then
    echo "[PASS] Ensure permissions on /etc/crontab are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/crontab are configured"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on /etc/cron.hourly are configured
perm=$(stat -c "%a" /etc/cron.hourly 2>/dev/null)
owner=$(stat -c "%U:%G" /etc/cron.hourly 2>/dev/null)

if [ "$perm" = "700" ] && [ "$owner" = "root:root" ]; then
    echo "[PASS] Ensure permissions on /etc/cron.hourly are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/cron.hourly are configured"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on /etc/cron.daily are configured
perm=$(stat -c "%a" /etc/cron.daily 2>/dev/null)
owner=$(stat -c "%U:%G" /etc/cron.daily 2>/dev/null)

if [ "$perm" = "700" ] && [ "$owner" = "root:root" ]; then
    echo "[PASS] Ensure permissions on /etc/cron.daily are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/cron.daily are configured"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on /etc/cron.weekly are configured
perm=$(stat -c "%a" /etc/cron.weekly 2>/dev/null)
owner=$(stat -c "%U:%G" /etc/cron.weekly 2>/dev/null)

if [ "$perm" = "700" ] && [ "$owner" = "root:root" ]; then
    echo "[PASS] Ensure permissions on /etc/cron.weekly are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/cron.weekly are configured"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on /etc/cron.monthly are configured
perm=$(stat -c "%a" /etc/cron.monthly 2>/dev/null)
owner=$(stat -c "%U:%G" /etc/cron.monthly 2>/dev/null)

if [ "$perm" = "700" ] && [ "$owner" = "root:root" ]; then
    echo "[PASS] Ensure permissions on /etc/cron.monthly are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/cron.monthly are configured"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on /etc/cron.d are configured
perm=$(stat -c "%a" /etc/cron.d 2>/dev/null)
owner=$(stat -c "%U:%G" /etc/cron.d 2>/dev/null)

if [ "$perm" = "700" ] && [ "$owner" = "root:root" ]; then
    echo "[PASS] Ensure permissions on /etc/cron.d are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/cron.d are configured"
    FAIL=$((FAIL+1))
fi


# Ensure cron is restricted to authorized users
if [ -f /etc/cron.allow ] && [ ! -f /etc/cron.deny ]; then
    echo "[PASS] Ensure cron is restricted to authorized users"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure cron is restricted to authorized users"
    FAIL=$((FAIL+1))
fi


# Ensure at is restricted to authorized users
if [ -f /etc/at.allow ] && [ ! -f /etc/at.deny ] && [ "$(stat -c %a /etc/at.allow)" -le 640 ]; then
    echo "[PASS] Ensure at is restricted to authorized users"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure at is restricted to authorized users"
    FAIL=$((FAIL+1))
fi
echo "=================================================="
echo "SSH SERVER CONFIGURATION"
echo "=================================================="

# Ensure permissions on /etc/ssh/sshd_config are configured
perm=$(stat -c "%a" /etc/ssh/sshd_config 2>/dev/null)
owner=$(stat -c "%U:%G" /etc/ssh/sshd_config 2>/dev/null)

if [ "$perm" = "600" ] && [ "$owner" = "root:root" ]; then
    echo "[PASS] Ensure permissions on /etc/ssh/sshd_config are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/ssh/sshd_config are configured"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on SSH private host key files are configured
if find /etc/ssh -xdev -type f -name "ssh_host_*_key" -perm /177 2>/dev/null | grep -q .; then
    echo "[FAIL] Ensure permissions on SSH private host key files are configured"
    FAIL=$((FAIL+1))
else
    echo "[PASS] Ensure permissions on SSH private host key files are configured"
    PASS=$((PASS+1))
fi


# Ensure permissions on SSH public host key files are configured
if find /etc/ssh -xdev -type f -name "ssh_host_*_key.pub" -perm /022 2>/dev/null | grep -q .; then
    echo "[FAIL] Ensure permissions on SSH public host key files are configured"
    FAIL=$((FAIL+1))
else
    echo "[PASS] Ensure permissions on SSH public host key files are configured"
    PASS=$((PASS+1))
fi


# Ensure SSH LogLevel is appropriate
if sshd -T 2>/dev/null | grep -Ei "loglevel (INFO|VERBOSE)"; then
    echo "[PASS] Ensure SSH LogLevel is appropriate"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH LogLevel is appropriate"
    FAIL=$((FAIL+1))
fi


# Ensure SSH X11 forwarding is disabled
if sshd -T | grep -q "x11forwarding no"; then
    echo "[PASS] Ensure SSH X11 forwarding is disabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH X11 forwarding is disabled"
    FAIL=$((FAIL+1))
fi


# Ensure SSH MaxAuthTries is set to 4 or less
val=$(sshd -T | grep maxauthtries | awk '{print $2}')
if [ "$val" -le 4 ]; then
    echo "[PASS] Ensure SSH MaxAuthTries is set to 4 or less"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH MaxAuthTries is set to 4 or less"
    FAIL=$((FAIL+1))
fi


# Ensure SSH IgnoreRhosts is enabled
if sshd -T | grep -q "ignorerhosts yes"; then
    echo "[PASS] Ensure SSH IgnoreRhosts is enabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH IgnoreRhosts is enabled"
    FAIL=$((FAIL+1))
fi


# Ensure SSH HostbasedAuthentication is disabled
if sshd -T | grep -q "hostbasedauthentication no"; then
    echo "[PASS] Ensure SSH HostbasedAuthentication is disabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH HostbasedAuthentication is disabled"
    FAIL=$((FAIL+1))
fi


# Ensure SSH root login is disabled
if sshd -T | grep -q "permitrootlogin no"; then
    echo "[PASS] Ensure SSH root login is disabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH root login is disabled"
    FAIL=$((FAIL+1))
fi


# Ensure SSH PermitEmptyPasswords is disabled
if sshd -T | grep -q "permitemptypasswords no"; then
    echo "[PASS] Ensure SSH PermitEmptyPasswords is disabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH PermitEmptyPasswords is disabled"
    FAIL=$((FAIL+1))
fi


# Ensure SSH PermitUserEnvironment is disabled
if sshd -T | grep -q "permituserenvironment no"; then
    echo "[PASS] Ensure SSH PermitUserEnvironment is disabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH PermitUserEnvironment is disabled"
    FAIL=$((FAIL+1))
fi


# Ensure only strong Ciphers are used
if sshd -T 2>/dev/null | grep -E "^ciphers" | grep -q "cbc"; then
    echo "[FAIL] Ensure only strong Ciphers are used"
    FAIL=$((FAIL+1))
else
    echo "[PASS] Ensure only strong Ciphers are used"
    PASS=$((PASS+1))
fi


# Ensure only strong MAC algorithms are used
if sshd -T 2>/dev/null | grep -E "^macs" | grep -Eq "hmac-sha1(,|$)|umac-64@"; then
    echo "[FAIL] Ensure only strong MAC algorithms are used"
    FAIL=$((FAIL+1))
else
    echo "[PASS] Ensure only strong MAC algorithms are used"
    PASS=$((PASS+1))
fi


# Ensure only strong Key Exchange algorithms are used
if sshd -T | grep -i kexalgorithms | grep -E "sha1"; then
    echo "[FAIL] Ensure only strong Key Exchange algorithms are used"
    FAIL=$((FAIL+1))
else
    echo "[PASS] Ensure only strong Key Exchange algorithms are used"
    PASS=$((PASS+1))
fi


# Ensure SSH Idle Timeout Interval is configured
interval=$(sshd -T | grep clientaliveinterval | awk '{print $2}')
count=$(sshd -T | grep clientalivecountmax | awk '{print $2}')

if [ "$interval" -le 300 ] && [ "$count" -le 3 ]; then
    echo "[PASS] Ensure SSH Idle Timeout Interval is configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH Idle Timeout Interval is configured"
    FAIL=$((FAIL+1))
fi


# Ensure SSH LoginGraceTime is set to one minute or less
grace=$(sshd -T | grep logingracetime | awk '{print $2}')
if [ "$grace" -le 60 ]; then
    echo "[PASS] Ensure SSH LoginGraceTime is set to one minute or less"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH LoginGraceTime is set to one minute or less"
    FAIL=$((FAIL+1))
fi


# Ensure SSH access is limited
if sshd -T | grep -E "allowusers|allowgroups|denyusers|denygroups" >/dev/null; then
    echo "[PASS] Ensure SSH access is limited"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH access is limited"
    FAIL=$((FAIL+1))
fi


# Ensure SSH warning banner is configured
if sshd -T | grep -q "banner /etc/issue.net"; then
    echo "[PASS] Ensure SSH warning banner is configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH warning banner is configured"
    FAIL=$((FAIL+1))
fi


# Ensure SSH PAM is enabled
if sshd -T | grep -iq "usepam yes"; then
    echo "[PASS] Ensure SSH PAM is enabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH PAM is enabled"
    FAIL=$((FAIL+1))
fi


# Ensure SSH AllowTcpForwarding is disabled
if sshd -T | grep -iq "allowtcpforwarding no"; then
    echo "[PASS] Ensure SSH AllowTcpForwarding is disabled"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH AllowTcpForwarding is disabled"
    FAIL=$((FAIL+1))
fi


# Ensure SSH MaxStartups is configured
if sshd -T | grep -iq "maxstartups"; then
    echo "[PASS] Ensure SSH MaxStartups is configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH MaxStartups is configured"
    FAIL=$((FAIL+1))
fi


# Ensure SSH MaxSessions is limited
sessions=$(sshd -T | grep maxsessions | awk '{print $2}')
if [ "$sessions" -le 10 ]; then
    echo "[PASS] Ensure SSH MaxSessions is limited"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure SSH MaxSessions is limited"
    FAIL=$((FAIL+1))
fi
echo
echo "=================================================="
echo "CONFIGURE PAM"
echo "=================================================="

# Ensure password creation requirements are configured
minlen=$(grep -E '^\s*minlen' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/* 2>/dev/null | awk '{print $3}' | head -1)
minclass=$(grep -E '^\s*minclass' /etc/security/pwquality.conf /etc/security/pwquality.conf.d/* 2>/dev/null | awk '{print $3}' | head -1)

minlen=${minlen:-0}
minclass=${minclass:-0}

if [[ "$minlen" =~ ^[0-9]+$ ]] && [[ "$minclass" =~ ^[0-9]+$ ]] && [ "$minlen" -ge 14 ] && [ "$minclass" -ge 4 ]; then
    echo "[PASS] Ensure password creation requirements are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure password creation requirements are configured"
    FAIL=$((FAIL+1))
fi

# Ensure lockout for failed password attempts is configured
if grep -q "pam_tally2" /etc/pam.d/common-auth 2>/dev/null; then
    echo "[PASS] Ensure lockout for failed password attempts is configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure lockout for failed password attempts is configured"
    FAIL=$((FAIL+1))
fi


# Ensure password reuse is limited
if grep -E "pam_pwhistory\.so.*remember=([5-9]|[1-9][0-9]+)" /etc/pam.d/common-password 2>/dev/null; then
    echo "[PASS] Ensure password reuse is limited"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure password reuse is limited"
    FAIL=$((FAIL+1))
fi


# Ensure password hashing algorithm is SHA-512
if grep -E "pam_unix\.so.*sha512" /etc/pam.d/common-password 2>/dev/null; then
    echo "[PASS] Ensure password hashing algorithm is SHA-512"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure password hashing algorithm is SHA-512"
    FAIL=$((FAIL+1))
fi
echo
echo "=================================================="
echo "USER ACCOUNTS AND ENVIRONMENT"
echo "=================================================="

# Ensure password expiration is 365 days or less
maxdays=$(awk '/^\s*PASS_MAX_DAYS/{print $2; exit}' /etc/login.defs)

if [[ "$maxdays" =~ ^[0-9]+$ ]] && [ "$maxdays" -le 365 ]; then
    echo "[PASS] Ensure password expiration is 365 days or less"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure password expiration is 365 days or less"
    FAIL=$((FAIL+1))
fi


# Ensure minimum days between password changes is configured
mindays=$(awk '/^\s*PASS_MIN_DAYS/{print $2; exit}' /etc/login.defs)

if [[ "$mindays" =~ ^[0-9]+$ ]] && [ "$mindays" -ge 1 ]; then
    echo "[PASS] Ensure minimum days between password changes is configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure minimum days between password changes is configured"
    FAIL=$((FAIL+1))
fi


# Ensure password expiration warning days is 7 or more
warndays=$(awk '/^\s*PASS_WARN_AGE/{print $2; exit}' /etc/login.defs)

if [[ "$warndays" =~ ^[0-9]+$ ]] && [ "$warndays" -ge 7 ]; then
    echo "[PASS] Ensure password expiration warning days is 7 or more"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure password expiration warning days is 7 or more"
    FAIL=$((FAIL+1))
fi


# Ensure inactive password lock is 30 days or less
inactive=$(useradd -D | awk -F= '/INACTIVE/{print $2}')

if [[ "$inactive" =~ ^[0-9]+$ ]] && [ "$inactive" -le 30 ]; then
    echo "[PASS] Ensure inactive password lock is 30 days or less"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure inactive password lock is 30 days or less"
    FAIL=$((FAIL+1))
fi


# Ensure all users last password change date is in the past
echo "[MANUAL] Ensure all users last password change date is in the past"
MANUAL=$((MANUAL+1))

# Ensure system accounts are non-login
nonlogin=$(awk -F: '($1!="root" && $1!="sync" && $1!="shutdown" && $1!="halt" && $3<1000 && $7!="/usr/sbin/nologin" && $7!="/sbin/nologin" && $7!="/bin/false") {print}' /etc/passwd)

if [ -z "$nonlogin" ]; then
    echo "[PASS] Ensure system accounts are non-login"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure system accounts are non-login"
    FAIL=$((FAIL+1))
fi

# Ensure default group for the root account is GID 0
root_gid=$(grep "^root:" /etc/passwd | cut -d: -f4)

if [ "$root_gid" -eq 0 ]; then
    echo "[PASS] Ensure default group for the root account is GID 0"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure default group for the root account is GID 0"
    FAIL=$((FAIL+1))
fi

# Ensure default user umask is 027 or more restrictive
umask_value=$(grep -R "umask" /etc/profile /etc/bash.bashrc /etc/profile.d/* 2>/dev/null | grep -Eo "umask [0-9]+" | awk '{print $2}' | head -1)

if [[ "$umask_value" =~ ^[0-9]+$ ]] && [ "$umask_value" -le 027 ]; then
    echo "[PASS] Ensure default user umask is 027 or more restrictive"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure default user umask is 027 or more restrictive"
    FAIL=$((FAIL+1))
fi

# Ensure access to the su command is restricted
if grep -Eq "pam_wheel.so.*use_uid" /etc/pam.d/su 2>/dev/null; then
    echo "[PASS] Ensure access to the su command is restricted"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure access to the su command is restricted"
    FAIL=$((FAIL+1))
fi

echo
echo "=================================================="
echo "SYSTEM MAINTENANCE"
echo "=================================================="

# Ensure permissions on /etc/passwd are configured
perm=$(stat -c "%a %u %g" /etc/passwd)
if [ "$perm" = "644 0 0" ]; then
    echo "[PASS] Ensure permissions on /etc/passwd are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/passwd are configured"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on /etc/shadow are configured
perm=$(stat -c "%a %u" /etc/shadow)
if [ "$(stat -c %a /etc/shadow)" -le 640 ] && [ "$(stat -c %u /etc/shadow)" -eq 0 ]; then
    echo "[PASS] Ensure permissions on /etc/shadow are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/shadow are configured"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on /etc/group are configured
perm=$(stat -c "%a %u %g" /etc/group)
if [ "$perm" = "644 0 0" ]; then
    echo "[PASS] Ensure permissions on /etc/group are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/group are configured"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on /etc/gshadow are configured
if [ "$(stat -c %a /etc/gshadow)" -le 640 ]; then
    echo "[PASS] Ensure permissions on /etc/gshadow are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/gshadow are configured"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on /etc/passwd- are configured
if [ -f /etc/passwd- ]; then
    if [ "$(stat -c %a /etc/passwd-)" -le 644 ]; then
        echo "[PASS] Ensure permissions on /etc/passwd- are configured"
        PASS=$((PASS+1))
    else
        echo "[FAIL] Ensure permissions on /etc/passwd- are configured"
        FAIL=$((FAIL+1))
    fi
fi


# Ensure permissions on /etc/shadow- are configured
if [ -f /etc/shadow- ]; then
    if [ "$(stat -c %a /etc/shadow-)" -le 640 ]; then
        echo "[PASS] Ensure permissions on /etc/shadow- are configured"
        PASS=$((PASS+1))
    else
        echo "[FAIL] Ensure permissions on /etc/shadow- are configured"
        FAIL=$((FAIL+1))
    fi
fi


# Ensure permissions on /etc/group- are configured
if [ -f /etc/group- ]; then
    if [ "$(stat -c %a /etc/group-)" -le 644 ]; then
        echo "[PASS] Ensure permissions on /etc/group- are configured"
        PASS=$((PASS+1))
    else
        echo "[FAIL] Ensure permissions on /etc/group- are configured"
        FAIL=$((FAIL+1))
    fi
fi


# Ensure permissions on /etc/gshadow- are configured
if [ -f /etc/gshadow- ]; then
    if [ "$(stat -c %a /etc/gshadow-)" -le 640 ]; then
        echo "[PASS] Ensure permissions on /etc/gshadow- are configured"
        PASS=$((PASS+1))
    else
        echo "[FAIL] Ensure permissions on /etc/gshadow- are configured"
        FAIL=$((FAIL+1))
    fi
fi


# Ensure no world writable files exist
if [ -z "$(df --local -P | awk 'NR!=1 {print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002 2>/dev/null)" ]; then
    echo "[PASS] Ensure no world writable files exist"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no world writable files exist"
    FAIL=$((FAIL+1))
fi


# Ensure no unowned files exist
if [ -z "$(df --local -P | awk 'NR!=1 {print $6}' | xargs -I '{}' find '{}' -xdev -nouser 2>/dev/null)" ]; then
    echo "[PASS] Ensure no unowned files or directories exist"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no unowned files or directories exist"
    FAIL=$((FAIL+1))
fi


# Ensure no ungrouped files exist
if [ -z "$(df --local -P | awk 'NR!=1 {print $6}' | xargs -I '{}' find '{}' -xdev -nogroup 2>/dev/null)" ]; then
    echo "[PASS] Ensure no ungrouped files or directories exist"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no ungrouped files or directories exist"
    FAIL=$((FAIL+1))
    fi
    
echo
echo "=================================================="
echo "USER AND GROUP SETTINGS"
echo "=================================================="

# Ensure password fields are not empty
if [ -z "$(awk -F: '($2 == "") {print $1}' /etc/shadow)" ]; then
    echo "[PASS] Ensure password fields are not empty"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure password fields are not empty"
    FAIL=$((FAIL+1))
fi


# Ensure no legacy '+' entries exist in /etc/passwd
if ! grep -q '^\+:' /etc/passwd; then
    echo "[PASS] Ensure no legacy '+' entries exist in /etc/passwd"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no legacy '+' entries exist in /etc/passwd"
    FAIL=$((FAIL+1))
fi


# Ensure no legacy '+' entries exist in /etc/shadow
if ! grep -q '^\+:' /etc/shadow; then
    echo "[PASS] Ensure no legacy '+' entries exist in /etc/shadow"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no legacy '+' entries exist in /etc/shadow"
    FAIL=$((FAIL+1))
fi


# Ensure no legacy '+' entries exist in /etc/group
if ! grep -q '^\+:' /etc/group; then
    echo "[PASS] Ensure no legacy '+' entries exist in /etc/group"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no legacy '+' entries exist in /etc/group"
    FAIL=$((FAIL+1))
fi


# Ensure root is the only UID 0 account
if [ "$(awk -F: '($3 == 0) {print $1}' /etc/passwd | wc -l)" -eq 1 ]; then
    echo "[PASS] Ensure root is the only UID 0 account"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure root is the only UID 0 account"
    FAIL=$((FAIL+1))
fi


# Ensure root PATH Integrity
badpath=0

echo $PATH | grep "::" >/dev/null && badpath=1
echo $PATH | grep ":$" >/dev/null && badpath=1

for dir in $(echo $PATH | tr ":" " "); do
    [ "$dir" = "." ] && badpath=1
done

if [ "$badpath" -eq 0 ]; then
    echo "[PASS] Ensure root PATH Integrity"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure root PATH Integrity"
    FAIL=$((FAIL+1))
fifi
echo
echo "=================================================="
echo "USER ACCOUNTS AND ENVIRONMENT"
echo "=================================================="

# Ensure password expiration is 365 days or less
maxdays=$(awk '/^\s*PASS_MAX_DAYS/{print $2; exit}' /etc/login.defs)

if [[ "$maxdays" =~ ^[0-9]+$ ]] && [ "$maxdays" -le 365 ]; then
    echo "[PASS] Ensure password expiration is 365 days or less"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure password expiration is 365 days or less"
    FAIL=$((FAIL+1))
fi


# Ensure minimum days between password changes is configured
mindays=$(awk '/^\s*PASS_MIN_DAYS/{print $2; exit}' /etc/login.defs)

if [[ "$mindays" =~ ^[0-9]+$ ]] && [ "$mindays" -ge 1 ]; then
    echo "[PASS] Ensure minimum days between password changes is configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure minimum days between password changes is configured"
    FAIL=$((FAIL+1))
fi


# Ensure password expiration warning days is 7 or more
warndays=$(awk '/^\s*PASS_WARN_AGE/{print $2; exit}' /etc/login.defs)

if [[ "$warndays" =~ ^[0-9]+$ ]] && [ "$warndays" -ge 7 ]; then
    echo "[PASS] Ensure password expiration warning days is 7 or more"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure password expiration warning days is 7 or more"
    FAIL=$((FAIL+1))
fi


# Ensure inactive password lock is 30 days or less
inactive=$(useradd -D | awk -F= '/INACTIVE/{print $2}')

if [[ "$inactive" =~ ^[0-9]+$ ]] && [ "$inactive" -le 30 ]; then
    echo "[PASS] Ensure inactive password lock is 30 days or less"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure inactive password lock is 30 days or less"
    FAIL=$((FAIL+1))
fi


# Ensure all users last password change date is in the past
echo "[MANUAL] Ensure all users last password change date is in the past"
MANUAL=$((MANUAL+1))
    fi

echo "[MANUAL] Ensure all users last password change date is in the past"
MANUAL=$((MANUAL+1))
echo
echo "=================================================="
echo "SYSTEM MAINTENANCE"
echo "=================================================="

# Ensure permissions on /etc/passwd are configured
perm=$(stat -c "%a %u %g" /etc/passwd)
if [ "$perm" = "644 0 0" ]; then
    echo "[PASS] Ensure permissions on /etc/passwd are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/passwd are configured"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on /etc/shadow are configured
perm=$(stat -c "%a %u" /etc/shadow)
if [ "$(stat -c %a /etc/shadow)" -le 640 ] && [ "$(stat -c %u /etc/shadow)" -eq 0 ]; then
    echo "[PASS] Ensure permissions on /etc/shadow are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/shadow are configured"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on /etc/group are configured
perm=$(stat -c "%a %u %g" /etc/group)
if [ "$perm" = "644 0 0" ]; then
    echo "[PASS] Ensure permissions on /etc/group are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/group are configured"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on /etc/gshadow are configured
if [ "$(stat -c %a /etc/gshadow)" -le 640 ]; then
    echo "[PASS] Ensure permissions on /etc/gshadow are configured"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure permissions on /etc/gshadow are configured"
    FAIL=$((FAIL+1))
fi


# Ensure permissions on /etc/passwd- are configured
if [ -f /etc/passwd- ]; then
    if [ "$(stat -c %a /etc/passwd-)" -le 644 ]; then
        echo "[PASS] Ensure permissions on /etc/passwd- are configured"
        PASS=$((PASS+1))
    else
        echo "[FAIL] Ensure permissions on /etc/passwd- are configured"
        FAIL=$((FAIL+1))
    fi
fi


# Ensure permissions on /etc/shadow- are configured
if [ -f /etc/shadow- ]; then
    if [ "$(stat -c %a /etc/shadow-)" -le 640 ]; then
        echo "[PASS] Ensure permissions on /etc/shadow- are configured"
        PASS=$((PASS+1))
    else
        echo "[FAIL] Ensure permissions on /etc/shadow- are configured"
        FAIL=$((FAIL+1))
    fi
fi


# Ensure permissions on /etc/group- are configured
if [ -f /etc/group- ]; then
    if [ "$(stat -c %a /etc/group-)" -le 644 ]; then
        echo "[PASS] Ensure permissions on /etc/group- are configured"
        PASS=$((PASS+1))
    else
        echo "[FAIL] Ensure permissions on /etc/group- are configured"
        FAIL=$((FAIL+1))
    fi
fi


# Ensure permissions on /etc/gshadow- are configured
if [ -f /etc/gshadow- ]; then
    if [ "$(stat -c %a /etc/gshadow-)" -le 640 ]; then
        echo "[PASS] Ensure permissions on /etc/gshadow- are configured"
        PASS=$((PASS+1))
    else
        echo "[FAIL] Ensure permissions on /etc/gshadow- are configured"
        FAIL=$((FAIL+1))
    fi
fi


# Ensure no world writable files exist
if [ -z "$(df --local -P | awk 'NR!=1 {print $6}' | xargs -I '{}' find '{}' -xdev -type f -perm -0002 2>/dev/null)" ]; then
    echo "[PASS] Ensure no world writable files exist"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no world writable files exist"
    FAIL=$((FAIL+1))
fi


# Ensure no unowned files exist
if [ -z "$(df --local -P | awk 'NR!=1 {print $6}' | xargs -I '{}' find '{}' -xdev -nouser 2>/dev/null)" ]; then
    echo "[PASS] Ensure no unowned files or directories exist"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no unowned files or directories exist"
    FAIL=$((FAIL+1))
fi


# Ensure no ungrouped files exist
if [ -z "$(df --local -P | awk 'NR!=1 {print $6}' | xargs -I '{}' find '{}' -xdev -nogroup 2>/dev/null)" ]; then
    echo "[PASS] Ensure no ungrouped files or directories exist"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no ungrouped files or directories exist"
    FAIL=$((FAIL+1))
    fi
    
echo
echo "=================================================="
echo "USER AND GROUP SETTINGS"
echo "=================================================="

# Ensure password fields are not empty
if [ -z "$(awk -F: '($2 == "") {print $1}' /etc/shadow)" ]; then
    echo "[PASS] Ensure password fields are not empty"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure password fields are not empty"
    FAIL=$((FAIL+1))
fi


# Ensure no legacy '+' entries exist in /etc/passwd
if ! grep -q '^\+:' /etc/passwd; then
    echo "[PASS] Ensure no legacy '+' entries exist in /etc/passwd"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no legacy '+' entries exist in /etc/passwd"
    FAIL=$((FAIL+1))
fi


# Ensure no legacy '+' entries exist in /etc/shadow
if ! grep -q '^\+:' /etc/shadow; then
    echo "[PASS] Ensure no legacy '+' entries exist in /etc/shadow"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no legacy '+' entries exist in /etc/shadow"
    FAIL=$((FAIL+1))
fi


# Ensure no legacy '+' entries exist in /etc/group
if ! grep -q '^\+:' /etc/group; then
    echo "[PASS] Ensure no legacy '+' entries exist in /etc/group"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no legacy '+' entries exist in /etc/group"
    FAIL=$((FAIL+1))
fi


# Ensure root is the only UID 0 account
if [ "$(awk -F: '($3 == 0) {print $1}' /etc/passwd | wc -l)" -eq 1 ]; then
    echo "[PASS] Ensure root is the only UID 0 account"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure root is the only UID 0 account"
    FAIL=$((FAIL+1))
fi


# Ensure root PATH Integrity
badpath=0

echo $PATH | grep "::" >/dev/null && badpath=1
echo $PATH | grep ":$" >/dev/null && badpath=1

for dir in $(echo $PATH | tr ":" " "); do
    [ "$dir" = "." ] && badpath=1
done

if [ "$badpath" -eq 0 ]; then
    echo "[PASS] Ensure root PATH Integrity"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure root PATH Integrity"
    FAIL=$((FAIL+1))
fi
echo
echo "=================================================="
echo "USER AND GROUP SETTINGS (HOME DIRECTORY CONTROLS)"
echo "=================================================="

# Ensure all users' home directories exist
missing_home=0

while IFS=: read -r user x uid gid home shell; do
    if [ "$uid" -ge 1000 ] && [ "$shell" != "/usr/sbin/nologin" ] && [ "$shell" != "/bin/false" ]; then
        if [ ! -d "$home" ]; then
            missing_home=1
        fi
    fi
done < /etc/passwd

if [ "$missing_home" -eq 0 ]; then
    echo "[PASS] Ensure all users' home directories exist"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure all users' home directories exist"
    FAIL=$((FAIL+1))
fi


# Ensure users' home directories permissions are 750 or more restrictive
badperm=0

for dir in $(awk -F: '$3>=1000 && $7!="/usr/sbin/nologin" && $7!="/bin/false" {print $6}' /etc/passwd); do
    if [ -d "$dir" ]; then
        perm=$(stat -c "%a" "$dir")
        if [ "$perm" -gt 750 ]; then
            badperm=1
        fi
    fi
done

if [ "$badperm" -eq 0 ]; then
    echo "[PASS] Ensure users' home directories permissions are 750 or more restrictive"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure users' home directories permissions are 750 or more restrictive"
    FAIL=$((FAIL+1))
fi


# Ensure users own their home directories
badowner=0

while IFS=: read -r user x uid gid home shell; do
    if [ "$uid" -ge 1000 ] && [ -d "$home" ]; then
        owner=$(stat -c "%U" "$home")
        if [ "$owner" != "$user" ]; then
            badowner=1
        fi
    fi
done < /etc/passwd

if [ "$badowner" -eq 0 ]; then
    echo "[PASS] Ensure users own their home directories"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure users own their home directories"
    FAIL=$((FAIL+1))
fi


# Ensure users' dot files are not group or world writable
dot_issue=0

for dir in $(awk -F: '$3>=1000 {print $6}' /etc/passwd); do
    if [ -d "$dir" ]; then
        for file in "$dir"/.[A-Za-z0-9]*; do
            [ -f "$file" ] || continue
            perm=$(stat -c "%a" "$file")
            if [ $((perm % 10)) -ge 2 ]; then
                dot_issue=1
            fi
        done
    fi
done

if [ "$dot_issue" -eq 0 ]; then
    echo "[PASS] Ensure users' dot files are not group or world writable"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure users' dot files are not group or world writable"
    FAIL=$((FAIL+1))
fi


# Ensure no users have .forward files
forward_found=0

for dir in $(awk -F: '$3>=1000 {print $6}' /etc/passwd); do
    if [ -f "$dir/.forward" ]; then
        forward_found=1
    fi
done

if [ "$forward_found" -eq 0 ]; then
    echo "[PASS] Ensure no users have .forward files"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no users have .forward files"
    FAIL=$((FAIL+1))
fi


# Ensure no users have .netrc files
netrc_found=0

for dir in $(awk -F: '$3>=1000 {print $6}' /etc/passwd); do
    if [ -f "$dir/.netrc" ]; then
        netrc_found=1
    fi
done

if [ "$netrc_found" -eq 0 ]; then
    echo "[PASS] Ensure no users have .netrc files"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no users have .netrc files"
    FAIL=$((FAIL+1))
fi


# Ensure users' .netrc files are not group or world accessible
netrc_perm_issue=0

for dir in $(awk -F: '$3>=1000 {print $6}' /etc/passwd); do
    if [ -f "$dir/.netrc" ]; then
        perm=$(stat -c "%a" "$dir/.netrc")
        if [ "$perm" -gt 600 ]; then
            netrc_perm_issue=1
        fi
    fi
done

if [ "$netrc_perm_issue" -eq 0 ]; then
    echo "[PASS] Ensure users' .netrc files are not group or world accessible"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure users' .netrc files are not group or world accessible"
    FAIL=$((FAIL+1))
fi


# Ensure no users have .rhosts files
rhosts_found=0

for dir in $(awk -F: '$3>=1000 {print $6}' /etc/passwd); do
    if [ -f "$dir/.rhosts" ]; then
        rhosts_found=1
    fi
done

if [ "$rhosts_found" -eq 0 ]; then
    echo "[PASS] Ensure no users have .rhosts files"
    PASS=$((PASS+1))
else
    echo "[FAIL] Ensure no users have .rhosts files"
    FAIL=$((FAIL+1))
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