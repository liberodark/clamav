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

# Update ClamAV Def
freshclam

exec 9>"${lock}"
flock -n 9 || exit

# Scan
clamscan -i -r \
    --exclude-dir= "/var/lib/clamav/*" \
    --exclude-dir "/usr/local/maldetect/*" \
    --exclude-dir "/usr/NX/lib/perl/*" \
    "$dest" "$args"
