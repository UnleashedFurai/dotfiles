#!/bin/bash

# USAGE:
#     ./workspace-switcher.sh <function> <workspace>
#
#     functions:
#         change - navigates to the supplied workspace
#         move   - moves window to the supplied workspace
#
#     workspace:
#         a value between 1 and 10 corresponding to the workspace of that value on that monitor

function=$1
workspace_index=$2
current_monitor=""

# Get mouse position
eval "$(xdotool getmouselocation --shell)"
mouse_x=$X
mouse_y=$Y

# Get monitor geometry and determine current monitor
while read -r line; do
    MONITOR=$(echo "$line" | awk '{print $1}')
    GEOM=$(echo "$line" | grep -o '[0-9]\+x[0-9]\++[0-9]\++[0-9]\+')
    WIDTH=$(echo "$GEOM" | cut -d'x' -f1)
    HEIGHT=$(echo "$GEOM" | cut -d'x' -f2 | cut -d'+' -f1)
    X_OFF=$(echo "$GEOM" | cut -d'+' -f2)
    Y_OFF=$(echo "$GEOM" | cut -d'+' -f3)

    if (( mouse_x >= X_OFF && mouse_x < X_OFF + WIDTH && mouse_y >= Y_OFF && mouse_y < Y_OFF + HEIGHT )); then
        current_monitor="$MONITOR"
        break
    fi
done < <(xrandr | grep ' connected')

# Decide action
case "$function" in
    change)
        case "$current_monitor" in
            DP-2)
                i3-msg "workspace number $workspace_index"
                ;;
            DP-3)
                i3-msg "workspace number $(($workspace_index+10))"
                ;;
            *)
                i3-nagbar -m "error: current monitor not detected correctly"
                ;;
        esac
        ;;
    move)
        case "$current_monitor" in
            DP-2)
                i3-msg "move container to workspace number $workspace_index"
                ;;
            DP-3)
                i3-msg "move container to workspace number $(($workspace_index+10))"
                ;;
            *)
                i3-nagbar -m "error: current monitor not detected correctly"
                ;;
        esac
        ;;
    *)
        i3-nagbar -m "error: this function does not exist"
        ;;
esac

