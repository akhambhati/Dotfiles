#!/usr/bin/env bash


# Set Variables
export DOTFILES=$HOME/Dotfiles
export DOTFILES_OLD=$HOME/Dotfiles_Old
export HOTH=$HOME/Hoth
export DEV=$HOME/Dev


echo "\n\nSetting up Hoth Research Systems..."
chmod ugo+rx $HOME/Dotfiles/helper.sh
. $HOME/Dotfiles/helper.sh


### Initial MacOS Prep
function initialUpdate() {
    # Check that we're on MacOS
    if [ "$(uname)" != 'Darwin']; then
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


### Setup Canonical Directory Structure
function assembleHoth() {
    mkdir -p $HOME/bin
    
    mkdir -p $HOTH/Repos/Docs
    mkdir -p $HOTH/Repos/Pkgs
    mkdir -p $HOTH/Repos/Rsrch
    mkdir -p $HOTH/Remotes
    
    mkdir -p $DEV/Repos
    mkdir -p $DEV/Compiles
}
assembleHoth


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
            
    # Create dotfiles_old in homedir
    echo -n "Creating $DOTFILES_OLD for backup of any existing dotfiles in $HOME..."
    mkdir -p $DOTFILES_OLD
    echo "done"
    
    # Change to the dotfiles directory
    echo -n "Changing to the $DOTFILES directory..."
    cd $DOTFILES
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
    echo "\nMoving any existing dotfiles from $HOME to $DOTFILES_OLD"
    for i in ${FILES_TO_SYMLINK[@]}; do
        mv $HOME/.${i##*/} $DOTFILES_OLD
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
        elif [ "$(uname)" == 'Darwin' ]; then
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
    if [ "$(uname)" != 'Darwin' ]; then
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


### Anaconda
function installAnaconda() {
    CONDA=$DEV/miniconda2
    
    # Install the miniconda environment
    if [ "$(uname)" == 'Darwin' ]; then
        curl -o $DEV/Compiles/conda_install.sh https://repo.continuum.io/miniconda/Miniconda-latest-MacOSX-x86_64.sh
    elif [ "$(uname)" == 'Linux' ]; then
        curl -o $DEV/Compiles/conda_install.sh https://repo.continuum.io/miniconda/Miniconda-latest-Linux-x86_64.sh
    else
        break
    fi    
    chmod ugo+x $DEV/Compiles/conda_install.sh
    $DEV/Compiles/conda_install.sh -p $CONDA

    # Create the cb environment
    conda env create -f $DOTFILES/conda/environment.yml

    # Remove the miniconda installer
    rm -r DEV/Compiles/conda_install.sh
}
installAnaconda

#source $HOME/.macos
