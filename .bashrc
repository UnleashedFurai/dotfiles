#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# otherwise start tmux
# [[ -z "$TMUX" ]] && exec tmux

#fastfetch

alias yay=paru
alias rm=trash
alias s=sudo
alias sedit=sudoedit

export PATH=$PATH:~/.local/bin

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    #fix gzdoom
    alias gzdoom='gzdoom -glversion 3.3'
    
    #fix dolphin-emu
    alias dolphin-emu='QT_QPA_PLATFORM=xcb dolphin-emu'
fi

#pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
