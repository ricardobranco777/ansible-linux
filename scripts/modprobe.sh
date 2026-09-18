#!/usr/bin/env bash

# Use this script to track modprobe calls and eventually set kernel.modules-disabled
# Adapted from https://docs.kernel.org/admin-guide/sysctl/kernel.html#modprobe

set -e

if [[ "$(</proc/sys/kernel/modprobe)" =~ (/usr)?/sbin/modprobe ]]; then
	echo "$0" > /proc/sys/kernel/modprobe
fi

log="/var/tmp/modprobe.log"

if [ ! -f "$log" ]; then
	install -m 0600 /dev/null "$log"
fi

date >> "$log"

echo "$@" >> "$log"

exec /sbin/modprobe "$@"
