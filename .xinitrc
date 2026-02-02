numlockx &

# points to ~/.config/assets/wallpaper.png
~/.fehbg &

dunst &
unclutter --timeout 5 &

# essentially just using for vsync
picom &

lock="loginctl lock-session | env \
XSECURELOCK_PASSWORD_PROMPT=time_hex \
XSECURELOCK_BLANK_TIMEOUT=10 \
XSECURELOCK_KEY_XF86AudioPlay_COMMAND='playerctl play-pause' \
XSECURELOCK_KEY_XF86AudioPause_COMMAND='playerctl play-pause' \
XSECURELOCK_KEY_XF86AudioNext_COMMAND='playerctl next' \
XSECURELOCK_KEY_XF86AudioPrev_COMMAND='playerctl previous' \
XSECURELOCK_KEY_XF86AudioMute_COMMAND='pactl set-sink-mute \@DEFAULT_SINK@ toggle' \
XSECURELOCK_KEY_XF86AudioLowerVolume_COMMAND='pactl set-sink-volume \@DEFAULT_SINK@ -5%' \
XSECURELOCK_KEY_XF86AudioRaiseVolume_COMMAND='pactl set-sink-volume \@DEFAULT_SINK@ +5%' \
XSECURELOCK_SAVER=saver_mpv \
XSECURELOCK_LIST_VIDEOS_COMMAND='find ~/.config/assets/lockscreen.png' \
XSECURELOCK_IMAGE_DURATION_SECONDS=3600 \
XSECURELOCK_SAVER_DELAY_MS=2 xsecurelock"
suspend="loginctl suspend"

xidlehook --not-when-audio \
    --timer 300 "$lock" '' \
    --timer 600 "$suspend" '' \
    --socket /tmp/idle.sock &

keepassxc &
polybar &
i3
