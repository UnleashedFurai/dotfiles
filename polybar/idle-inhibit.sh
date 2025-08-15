#!/usr/bin/env bash

XIDLEHOOK_SOCK="/tmp/idle.sock"

get_status() {
    socket=$(xidlehook-client --socket "$XIDLEHOOK_SOCK" query | grep disabled\s*.*true)
    if [ "$socket" ]; then
        echo "disabled"
    else
        echo "enabled"
    fi
}

toggle_status() {
    if [ $(get_status) == "disabled" ]; then
        xidlehook-client --socket "$XIDLEHOOK_SOCK" control --action Enable
    else
        xidlehook-client --socket "$XIDLEHOOK_SOCK" control --action Disable
    fi
}

case "$1" in
    "status")
        get_status
        sleep 1
        ;;
    "toggle")
        toggle_status
        ;;
esac
