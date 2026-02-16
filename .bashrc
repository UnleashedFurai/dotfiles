#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# otherwise start tmux
# [[ -z "$TMUX" ]] && exec tmux

alias rm=trash
alias s=sudo
alias sedit=sudoedit

export PATH=$PATH:~/.local/bin

#pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
