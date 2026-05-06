alias rm=trash
alias s=sudo
alias sedit=sudoedit
alias e=$EDITOR

alias emacs='emacsclient -a "" -n -r'

if [[ -z $DISPLAY && "$(tty 2>/dev/null)" == "/dev/tty1" ]]; then
	exec startx
fi
