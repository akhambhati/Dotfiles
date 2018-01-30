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
initial_update

### Warn existing Dotfiles will be overwritten
function overwriteDotfiles() {
    while true; do
        read -p "Warning: this will overwrite your current dotfiles. Continue? [y/n] " yn
        case $yn in
            [Yy]* ) break;;
            [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
        esac
    done
        
    # Get the dotfiles directory's absolute path
    SCRIPT_DIR="$(cd "$(dirname "$0")"; pwd -P)"
    DOTFILES_DIR="$(dirname "$SCRIPT_DIR")"

    dir=~/Dotfiles                        # dotfiles directory
    dir_backup=~/Dotfiles_old             # old dotfiles backup directory

    # Get current dir (so run this script from anywhere)
    export DOTFILES_DIR
    DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    
    # Create dotfiles_old in homedir
    echo -n "Creating $dir_backup for backup of any existing dotfiles in ~..."
    mkdir -p $dir_backup
    echo "done"
    
    # Change to the dotfiles directory
    echo -n "Changing to the $dir directory..."
    cd $dir
    echo "done"        
}
overwriteDotfiles

### Symlinking
declare -a FILES_TO_SYMLINK=(

  'shell/shell_aliases'
  'shell/shell_config'
  'shell/shell_exports'
  'shell/shell_functions'
  'shell/bash_profile'
  'shell/bash_prompt'
  'shell/bashrc'
  'shell/zshrc'
  'shell/ackrc'
  'shell/curlrc'
  'shell/gemrc'
  'shell/inputrc'
  'shell/screenrc'

  'git/gitattributes'
  'git/gitconfig'
  'git/gitignore'
  
  

)


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
curl -L git.io/antigen > antigen.zsh
