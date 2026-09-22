#!/usr/bin/env bash

# Use this script to track modprobe calls and eventually set kernel.modules-disabled
# Adapted from https://docs.kernel.org/admin-guide/sysctl/kernel.html#modprobe

set -e

if [[ "$(</proc/sys/kernel/modprobe)" =~ ^(/usr)?/s?bin/modprobe$ ]]; then
	echo "$0" > /proc/sys/kernel/modprobe
fi

if [ $# -eq 0 ]; then
	exit 0
fi

log="/var/log/modprobe.log"

if [ ! -f "$log" ]; then
	install -m 0600 /dev/null "$log"
fi

date >> "$log"
printf "%s\n" "$*" >> "$log"

if command -v notify-send >/dev/null 2>&1 && [[ "$(</proc/1/comm)" = systemd ]]; then
	loginctl list-sessions --no-legend --no-pager 2>/dev/null | \
	while read -r SESSION_ID SESSION_UID USER _ETC; do
		SESSION_TYPE=$(loginctl show-session "$SESSION_ID" -p Type --value 2>/dev/null)
		case "$SESSION_TYPE" in
		wayland|x11)
			DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$SESSION_UID/bus" \
			runuser -u "$USER" -- notify-send -u critical -i dialog-warning "modprobe" "$*" 2>/dev/null ||:
			;;
		esac
	done
fi

exec /sbin/modprobe "$@"
