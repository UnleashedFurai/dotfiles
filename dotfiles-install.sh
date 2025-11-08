#!/usr/bin/env bash

if [[ ! "$(pwd)" == "$HOME/.config" ]]; then
    printf '%s\n' "WARNING: this repo must be cloned and installed from $HOME/.config"
    exit 1
fi

ln -s ~/.config/fluxbox ~/.fluxbox
ln -s ~/.config/fvwm ~/.fvwm
ln -s ~/.config/vim ~/.vim
ln -s ~/.config/vim/vimrc ~/.vimrc
ln -s ~/.config/wmaker ~/GNUstep
ln -s ~/.config/.bashrc ~/.bashrc
ln -s ~/.config/.xinitrc ~/.xinitrc
