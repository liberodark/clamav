#!/bin/bash
#
# About: ClamAV Scan
# Author: liberodark
# License: GNU GPLv3

version="0.1.0"

echo "Welcome on ClamAV Scan Script $version"

#=================================================
# CHECK ROOT
#=================================================

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

#=================================================
# RETRIEVE ARGUMENTS FROM THE MANIFEST AND VAR
#=================================================

dest="/home/pc/Documents/Scan_Virus/"
tmp_folder=$(mktemp -d -t virus-XXXXXXXXXX)
lock="/tmp/clamav-scan.lock"
#mail=$(tail /var/log/clamav/scan-"$date".log | grep "Infected files" | grep -v "Infected files: 0$" | ifne mail -s clamav_log_`hostname` support@example.com)
date=$(date +%Y.%m.%d_%H-%M-%S)

# Check user
if [ `id -u pc 2>/dev/null || echo -1` -ge 0 ]; then
groupadd clamav
useradd -g clamav -s /bin/false -c "Clam Antivirus" clamav
fi

# Check services
if [ -e /usr/lib/systemd/system/clamav-daemon.service ]; then
systemctl restart clamav-daemon
fi

# Create log folder
mkdir -p /var/log/clamav
chown -R clamav: /var/log/clamav

# SELinux
if [ -e /usr/sbin/getenforce ]; then
setsebool -P antivirus_can_scan_system 1
fi

# Kill Update
pkill freshclam
rm -f /var/log/clamav/freshclam.log

# Update ClamAV Def
freshclam -u clamav

exec 9>"${lock}"
flock -n 9 || exit

# Scan
clamdscan -i --fdpass \
    --log="/var/log/clamav/scan-"$date".log" \
    "$dest" --move="$tmp_folder"


# Virus
chmod -R 400 "$tmp_folder"
chown -R clamav "$tmp_folder"
echo "Infected files is in $tmp_folder"
