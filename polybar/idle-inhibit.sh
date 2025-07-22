#!/usr/bin/env bash

STATUS_FILE="/tmp/polybar_idle_inhibitor_status"

get_icon() {
  if [ -f "$STATUS_FILE" ]; then
    status=$(cat "$STATUS_FILE")
    if [ "$status" == "activated" ]; then
      echo ""
    else
      echo ""
    fi
  else
    echo "" 
  fi
}

toggle_status() {
  current_status=$(cat "$STATUS_FILE" 2>/dev/null || echo "deactivated")

  xautolock -toggle
  if [ "$current_status" == "activated" ]; then
    echo "deactivated" > "$STATUS_FILE"
  else
    echo "activated" > "$STATUS_FILE"
  fi
  # After toggling, force Polybar to update the module immediately
  polybar-msg hook idle-inhibitor 1 >/dev/null 2>&1
}

case "$1" in
  "get")
    get_icon
    ;;
  "toggle")
    toggle_status
    ;;
  *)
    # Default behavior if no argument or unknown argument (same as "get")
    get_icon
    ;;
esac
