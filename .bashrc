# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# otherwise start tmux
# [[ -z "$TMUX" ]] && exec tmux

if [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]] && [[ ! "$TERM" == "dumb" ]] ; then
	tmux a -t ssh || tmux new-session -s ssh
	exit
fi

alias rm=trash
alias s=sudo
alias sedit=sudoedit
alias e=$EDITOR

alias emacs='emacsclient -a "" -n -r'

export PATH=$PATH:~/.local/bin

#pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
