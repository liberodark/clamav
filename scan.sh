#!/bin/bash
#
# About: ClamAV Scan
# Author: liberodark
# License: GNU GPLv3

version="0.2.1"

echo "Welcome on ClamAV Scan Script $version"

#=================================================
# CHECK ROOT
#=================================================

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

#=================================================
# RETRIEVE ARGUMENTS FROM THE MANIFEST AND VAR
#=================================================

dest="/"
tmp_folder=$(mktemp -d -t virus-XXXXXXXXXX)
lock="/tmp/clamav-scan.lock"
mail_adress="myemail@gmail.com"
account="gmail"
date=$(date +%Y.%m.%d_%H-%M-%S)

# Check user
if [ "$(id -u clamav 2>/dev/null || echo -1)" -ge 0 ]; then
echo "user exist"
else
echo "user dont exist"
groupadd clamav
useradd -g clamav -s /bin/false -c "Clam Antivirus" clamav
fi

# Check service
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
    --log="/var/log/clamav/scan-""$date"".log" \
    "$dest" --move="$tmp_folder"

# Check & Send Mail
mail=$(cat /var/log/clamav/scan-"$date".log | msmtp -a "$account" "$mail_adress")
virus=$(tail /var/log/clamav/scan-"$date".log|grep Infected|cut -d" " -f3)

if [ "$virus" -ne "0" ];then
  chmod -R 400 "$tmp_folder"
  chown -R clamav: "$tmp_folder"
  echo "Infected files is in $tmp_folder"
  echo "Send Email"
  "$mail"
fi 
