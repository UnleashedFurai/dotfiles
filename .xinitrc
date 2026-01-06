xinput set-prop "DELL08B8:00 0488:121F Mouse" "libinput Scroll Method Enabled" 0 0 1
xinput set-prop "DELL08B8:00 0488:121F Mouse" "libinput Accel Speed" .5

xinput set-prop 'DELL08B8:00 0488:121F Touchpad' "libinput Natural Scrolling Enabled" 1

numlockx &

# points to ~/.config/assets/wallpaper.png
~/.fehbg &

dunst &
unclutter --timeout 5 &

# essentially just using for vsync (to stop tearing)
picom &

# lock="loginctl lock-session | i3lock -F -i ~/.config/assets/lockscreen.png"
# locker='i3lock'
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
locker='xsecurelock'
monitors_off="xset dpms force off"
xidlehook --not-when-audio \
    --timer 5 "if pgrep $locker; then $monitors_off; fi" '' \
    --timer 300 "$lock" '' \
    --socket /tmp/idle.sock &

keepassxc &
polybar &
i3
