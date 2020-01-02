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

dest="/"
lock="/tmp/clamav-scan.lock"
args=""
mail="| grep "Infected files" | grep -v "Infected files: 0$" | ifne mail -s clamav_log_`hostname` support@example.com"

# Update ClamAV Def
freshclam

exec 9>"${lock}"
flock -n 9 || exit

# Scan
clamscan -i -r \
    --exclude="/var/lib/clamav/" \
    --exclude="/usr/local/maldetect/" \
    --exclude="/usr/NX/lib/perl/" \
    --exclude="/usr/src/linux-headers-*-*-generic/arch/x86/purgatory/" \
    "$dest" "$args"
