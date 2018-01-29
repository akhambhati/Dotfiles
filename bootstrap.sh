#!/bin/sh

echo "Setting up Hoth Research Systems..."

### Setup Canonical Directory Structure
function assembleHoth() {
    mkdir -p ~/Hoth/Repos/Docs
    mkdir -p ~/Hoth/Repos/Pkgs
    mkdir -p ~/Hoth/Repos/Rsrch
    mkdir -p ~/Hoth/Sandbox
    mkdir -p ~/Hoth/Remotes
}

### Homebrew Section
function brewCantina() {
    # Check for Homebrew and install if we don't have it
    if test ! $(which brew); then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # Update Homebrew recipes
    brew update

    # Install all our dependencies with bundle (See Brewfile)
    brew tap homebrew/bundle
    brew bundle
}

### 

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
