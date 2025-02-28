#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
# otherwise start tmux
# [[ -z "$TMUX" ]] && exec tmux

fastfetch

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '

alias rm=trash
alias yt-dlp-sb='yt-dlp --sponsorblock-mark all --sponsorblock-remove sponsor,selfpromo'
alias auto-chap="/home/moth/Documents/various\ scripts/mkv/auto_chap.sh"
alias s=sudo
#alias n=nano
alias vi=vim
# learn vi buddy
alias n="echo fuck you, you\' using vim && sleep 3 && vim"
alias n="echo fuck you, you\' using vim && sleep 3 && vim"
alias neofetch=fastfetch

export PATH=$PATH:~/.local/bin

#fix gzdoom on hyprland
alias gzdoom='gzdoom -glversion 3.3'

#fix dolphin-emu
alias dolphin-emu='QT_QPA_PLATFORM=xcb dolphin-emu'

#pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"
