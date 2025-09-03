export GTK_IM_MODULE='ibus'
export QT_IM_MODULE='ibus'
export GLFW_IM_MODULE='ibus'
export XMODIFIERS='@IM=ibus'

xrandr --output DP-2 --mode 2560x1440 --rate 120 --pos 0x0 --primary --output DP-3 --mode 1920x1080 --rate 120 --pos 2560x250

mouse_set='xinput set-prop "pointer:USB Gaming Mouse" "libinput Accel Profile Enabled" 0 1 0'
eval "$mouse_set"

xset dpms 0 0 0
xset s noblank
xset s off

numlockx &

# points to ~/.config/assets/wallpaper.png
~/.fehbg &

dunst &
unclutter --timeout 5 &

warpd &

# essentially just using for vsync (to stop tearing)
picom &

lock="i3lock -u -F -i ~/.config/assets/lockscreen.png --clock" 
monitors_off="xset dpms force off"
xidlehook --not-when-fullscreen \
    --timer 5 "if pgrep i3lock; then $monitors_off; fi" \
        'eval "$mouse_set"' \
    --timer 300 "$lock" '' \
    --socket /tmp/idle.sock &

~/.xsecrets

# declaring a window manager here allows me to hotswap to other window managers
i3 &

# to exit x, just kill sleep
sleep infinity
