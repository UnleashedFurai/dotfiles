#!/usr/bin/env bash

XIDLEHOOK_SOCK="/tmp/idle.sock"
MODULE="idle"

is_disabled() {
	xidlehook-client --socket "$XIDLEHOOK_SOCK" query | grep -q "disabled.*true"
}

toggle() {
	if is_disabled; then
		xidlehook-client --socket "$XIDLEHOOK_SOCK" control --action Enable
		polybar-msg hook "$MODULE" 2
	else
		xidlehook-client --socket "$XIDLEHOOK_SOCK" control --action Disable
		polybar-msg hook "$MODULE" 1
	fi
}

case "$1" in
	toggle)
		toggle
		;;
    status)
		is_disabled && echo "disabled" || echo "enabled"
        ;;
esac
