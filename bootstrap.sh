#!/usr/bin/env bash

echo "Setting up Hoth Research Systems..."
sh $HOME/Dotfiles/helper.sh

### Initial MacOS Prep
function initialUpdate() {
    # Check that we're on MacOS
    if [[ "($uname)" != 'Darwin']]; then
        break
    fi
    
    echo "Initial pre-setup updates..."
    ask_for_sudo    

    # Install all available updates
    echo "Updating OSX.  If this requires a restart, run the script again."
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

    dir=$HOME/Dotfiles                        # dotfiles directory
    dir_backup=$HOME/Dotfiles_old             # old dotfiles backup directory

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
function makeSymlinks() {

    declare -a FILES_TO_SYMLINK=(
        'git/gitconfig'
        'git/gitignore'

        'macos/macos'
        
        'shell/aliases'
        'shell/bindings'
        'shell/env'
        'shell/exports'
        'shell/history'
        'shell/zshrc'

        'vim/vimrc'
    )
    
    # Move any existing dotfiles in homedir to dotfiles_old directory
    for i in ${FILES_TO_SYMLINK[@]}; do
        echo "Moving any existing dotfiles from ~ to $dir_backup"
        mv ~/.${i##*/} ~/dotfiles_old/
    done
    
    # Create symlinks from the above list to home directory
    local i=''
    local sourceFile=''
    local targetFile=''
    for i in ${FILES_TO_SYMLINK[@]}; do
        sourceFile="$(pwd)/$i"
        targetFile="$HOME/.$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"
        
        if [ ! -e "$targetFile" ]; then
            execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
        elif [ "$(readlink "$targetFile")" == "$sourceFile" ]; then
            print_success "$targetFile → $sourceFile"
        else
            ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
            if answer_is_yes; then
                rm -rf "$targetFile"
                execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
            else
                print_error "$targetFile → $sourceFile"
            fi
        fi
    done   
    unset FILES_TO_SYMLINK
}
makeSymlinks


### Setup ZSH
function installZSH() {
    # Test to see if zshell is installed.  If it is:
    if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
        # Install Antigen if it isn't already present
        if [[ ! -e $HOME/bin/antigen.zsh ]]; then
            curl -L git.io/antigen > $HOME/bin/antigen.zsh
        fi
        # Set the default shell to zsh if it isn't currently set to zsh
        if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
            chsh -s $(which zsh)
        fi
    else
        # If the platform is Linux, try an apt-get to install zsh and then recurse
        if [[ "$(uname)" == 'Linux' ]]; then
            if [[ -f /etc/redhat-release ]]; then
                sudo yum install zsh
                install_zsh
            fi
            if [[ -f /etc/debian_version ]]; then
                sudo apt-get install zsh
                install_zsh
            fi
        # If the platform is OS X, tell the user to install zsh :)
        elif [[ "$(uname)" == 'Darwin' ]]; then
            echo "We'll install zsh, then you need to rerun this script!"
            brew install zsh
            exit
        fi
    fi
}
installZSH


### Homebrew Section
function brewCantina() {
    # Check that we're on MacOS
    if [[ "$(uname)" != 'Darwin']]; then
        break
    fi
    
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
brewCantina

### Setup Canonical Directory Structure
function assembleHoth() {
    mkdir -p $HOME/Hoth/Repos/Docs
    mkdir -p $HOME/Hoth/Repos/Pkgs
    mkdir -p $HOME/Hoth/Repos/Rsrch
    mkdir -p $HOME/Hoth/Sandbox
    mkdir -p $HOME/Hoth/Remotes
}
assembleHoth

#source $HOME/.macos
