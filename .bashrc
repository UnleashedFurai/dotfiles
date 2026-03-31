alias rm=trash
alias s=sudo
alias sedit=sudoedit

# alias emacs="emacsclient -t"

if [[ -z $DISPLAY && "$(tty 2>/dev/null)" == "/dev/tty1" ]]; then
	exec startx
fi
