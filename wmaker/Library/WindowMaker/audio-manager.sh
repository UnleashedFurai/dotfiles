#!/usr/bin/env bash

# functions:
#     toggle-mute
#     vol-raise
#     vol-lower


function=$1

case "$function" in
    toggle-mute)
        pactl set-sink-mute \@DEFAULT_SINK@ toggle
        ;;
    vol-raise)
        pactl set-sink-volume \@DEFAULT_SINK@ +5%
        ;;
    vol-lower)
        pactl set-sink-volume \@DEFAULT_SINK@ -5%
        ;;
    *)
        notify-send "error: this function is not implemented"
        ;;
esac
