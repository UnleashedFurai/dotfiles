#!/usr/bin/env bash

set -e

if [ "$XDG_SESSION_TYPE" = wayland ]; then
    COPY="wl-copy --primary"
    PASTE="wl-paste --primary"
else
    COPY="xclip -i"
    PASTE="xclip -o"
fi

case "$1" in
    in)
        cat | eval $COPY
        ;;
    out)
        eval $PASTE
        ;;
    *)
        exit 1
        ;;
esac
