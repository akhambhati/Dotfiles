#!/usr/bin/env zsh

git pull origin master;

function doIt() {
    mkdir ~/Developer
    mkdir ~/Remotes

    ln -s ~/Dotfiles/.gitconfig ~/.gitconfig
    ln -s ~/Dotfiles/.jupyter ~/.jupyter
    ln -s ~/Dotfiles/.tmux.conf ~/.tmux.conf
    ln -s ~/Dotfiles/.tmuxinator ~/.tmuxinator
    ln -s ~/Dotfiles/.vimrc ~/.vimrc
    ln -s ~/Dotfiles/.zshrc ~/.zshrc
    ln -s ~/Dotfiles/Library/Fonts/* ~/Library/Fonts
    
    . ~/.zshrc
}

if [ “$1”==“—force” -o “$1”==“-f” ]; then
    doIt;
else
    echo -n “This may overwrite existing files in your home directory. Are you sure?“
    read REPLY
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
unset doIt;