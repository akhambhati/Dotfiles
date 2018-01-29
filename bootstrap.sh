#!/usr/bin/env bash

### Initial MacOS Prep
function initialUpdate() {
    fancy_echo "Initial pre-setup updates..."
    
    # Ask for the administrator password upfront
    sudo -v

    # Keep-alive: update existing `sudo` time stamp until `osxprep.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    # Install all available updates
    fancy_echo "Updating OSX.  If this requires a restart, run the script again."
    sudo softwareupdate --verbose -ia
    
    # Install XCode    
    fancy_echo "Installing Xcode Command Line Tools."
    xcode-select --install
    
    # Install all available updates
    fancy_echo "Updating OSX.  If this requires a restart, run the script again."
    sudo softwareupdate --verbose -ia    
}

### Homebrew Section
function brewCantina() {
    # Check for Homebrew and install if we don't have it
    if test ! $(which brew); then
        /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    fi

    # Update Homebrew recipes
    brew update
    
    # Upgrade any already-installed formulae
    brew upgrade --all    

    # Install all our dependencies with bundle (See Brewfile)
    brew tap homebrew/bundle
    brew bundle
    
    # Remove outdated versions from cellar
    brew cleanup
}

### Setup Canonical Directory Structure
function assembleHoth() {
    mkdir -p ~/Hoth/Repos/Docs
    mkdir -p ~/Hoth/Repos/Pkgs
    mkdir -p ~/Hoth/Repos/Rsrch
    mkdir -p ~/Hoth/Sandbox
    mkdir -p ~/Hoth/Remotes
}

### ZSH
# Make ZSH the default shell environment
chsh -s $(which zsh)

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

fancy_echo "Setting up Hoth Research Systems..."

git clone https://github.com/akhambhati/Dotfiles.git $HOME/Dotfiles

source .macos
