#!/usr/bin/env bash


echo "Setting up Hoth Research Systems..."

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
function makeSymlinks() {

    declare -a FILES_TO_SYMLINK=(
        'git/gitconfig'
        'git/gitignore'

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
        # If zsh isn't installed, get the platform of the current machine
        platform=$(uname);
        # If the platform is Linux, try an apt-get to install zsh and then recurse
        if [[ $platform == 'Linux' ]]; then
            if [[ -f /etc/redhat-release ]]; then
                sudo yum install zsh
                install_zsh
            fi
            if [[ -f /etc/debian_version ]]; then
                sudo apt-get install zsh
                install_zsh
            fi
        # If the platform is OS X, tell the user to install zsh :)
        elif [[ $platform == 'Darwin' ]]; then
            echo "We'll install zsh, then you need to rerun this script!"
            brew install zsh
            exit
        fi
    fi
}
installZSH


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




source .macos=
