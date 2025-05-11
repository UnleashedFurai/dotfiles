#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# otherwise start tmux
# [[ -z "$TMUX" ]] && exec tmux

#fastfetch

alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias rm=trash
alias s=sudo
alias neofetch=fastfetch

export PATH=$PATH:~/.local/bin

#fix gzdoom on hyprland
alias gzdoom='gzdoom -glversion 3.3'

#fix dolphin-emu
alias dolphin-emu='QT_QPA_PLATFORM=xcb dolphin-emu'

#correctly launch ripcord-arch-libs from console
#alias ripcord="env LD_PRELOAD=/usr/lib/ripcord/hook.so QT_QPA_PLATFORM_PLUGIN_PATH=/usr/lib/qt/plugins ripcord"


#pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
