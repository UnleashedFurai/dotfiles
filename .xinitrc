export GTK_IM_MODULE='ibus'
export QT_IM_MODULE='ibus'
export GLFW_IM_MODULE='ibus'
export XMODIFIERS='@IM=ibus'

xrandr --output DP-2 --mode 2560x1440 --rate 144 --pos 0x0 --primary --output DP-3 --mode 1920x1080 --rate 144 --pos 2560x250
xinput set-prop "8" "libinput Accel Profile Enabled" 0 1 0
numlockx &

# points to ~/.config/assets/wallpaper.png
~/.fehbg &

dunst &
unclutter --timeout 5 &
~/.config/polybar/all-monitors.sh &

lock="i3lock -F -i ~/.config/assets/lockscreen.png"
monitors_on="xset dpms force on"
monitors_off="xset dpms force off"
xautolock -detectsleep -time 10 -locker "$lock | $monitors_off" &

fcitx5 &
keepassxc &

# declaring i3 here allows me to hotswap to other window managers, such as windowmaker or fluxbox
i3 &

# to exit x, just kill sleep
sleep infinity
