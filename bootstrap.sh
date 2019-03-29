#!/usr/bin/env bash


# Set Variables
export DOTFILES=$HOME/Dotfiles
export HOTH=$HOME/Hoth
export DEV=$HOME/Dev
export VIMDIR=$HOME/.vim
export CONDA=$DEV/miniconda3


echo "\n\nSetting up Hoth Research Systems..."
chmod ugo+rx $HOME/Dotfiles/helper.sh
. $HOME/Dotfiles/helper.sh


### Initial MacOS Prep
function initialUpdate() {
    # Check that we're on MacOS
    if [ "$(uname)" != 'Darwin' ]; then
        break
    fi
    
    echo "Initial pre-setup updates..."
    ask_for_sudo    

    # Install all available updates
    echo "Updating OSX.  If this requires a restart, run the script again."
    sudo softwareupdate --verbose -ia
    
    # Install XCode    
    echo "Installing Xcode Command Line Tools."
    xcode-select --install
    
    # Install all available updates
    echo "Updating OSX.  If this requires a restart, run the script again."
    sudo softwareupdate --verbose -ia    
}
initialUpdate


### Setup Canonical Directory Structure
function setupHoth() {
    mkdir -p $HOME/bin
    
    mkdir -p $HOTH/Repos/Docs
    mkdir -p $HOTH/Repos/Pkgs
    mkdir -p $HOTH/Repos/Rsrch
    mkdir -p $HOTH/Remotes
    
    mkdir -p $DEV/Repos
    mkdir -p $DEV/Compiles
}
setupHoth


### Symlinking
function setupSymlinks() {
    declare -a FILES_TO_SYMLINK=($(ls -d */*))
    
    # Create symlinks from the above list to home directory
    local i=''
    local sourceFile=''
    local targetFile=''
    for i in ${FILES_TO_SYMLINK[@]}; do
        # Check that the path does not start with 'cfg'
        if [[ "$(printf "%s" "$i" | cut -d'/' -f-1)" == 'cfg' ]]; then
            continue
        fi
        
        # Format the source and target files and begin linking
        sourceFile="$(pwd)/$i"
        targetFile="$HOME/.$(printf "%s" "$i" | cut -d'/' -f2-)"
        
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
setupSymlinks


### Anaconda
function setupAnaconda() {
    # Install the miniconda environment
    if [ "$(uname)" == 'Darwin' ]; then
        curl -o $DEV/Compiles/conda_install.sh https://repo.continuum.io/miniconda/Miniconda3-latest-MacOSX-x86_64.sh
    elif [ "$(uname)" == 'Linux' ]; then
        curl -o $DEV/Compiles/conda_install.sh https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
    else
        break
    fi    
    chmod ugo+x $DEV/Compiles/conda_install.sh
    $DEV/Compiles/conda_install.sh -p $CONDA -u

    # Create the cb environment
    $CONDA/bin/conda env create -f $DOTFILES/cfg/conda/environment.yml

    # Remove the miniconda installer
    rm -r $DEV/Compiles/conda_install.sh
}
setupAnaconda


### Homebrew Section
function setupCantina() {
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
    brew upgrade

    # Install all our dependencies with bundle (See Brewfile)
    brew tap homebrew/bundle
    brew bundle $DOTFILES/Brewfile
    
    # Remove outdated versions from cellar
    brew cleanup
}
setupCantina


### Setup ZSH
function setupZSH() {
    # Test to see if zshell is installed.  If it is:
    if [ -f /bin/zsh -o -f /usr/bin/zsh -o -f $HOME/bin/zsh ]; then
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
setupZSH


### Setup Term2
function setupTerm2() {
    # Check that we're on MacOS
    if [ "$(uname)" != 'Darwin' ]; then
        break
    fi
    
    # Install the Honukai theme for iTerm
    open "${DOTFILES}/cfg/iterm/honukai.itermcolors"

    # Don’t display the annoying prompt when quitting iTerm
    defaults write com.googlecode.iterm2 PromptOnQuit -bool false
}
setupTerm2


### Setup VIM
function setupVim() {
    # Alias to MacVim if on a MacOS
    if [ "$(uname)" == 'Darwin' ]; then
        alias vim="$(brew --prefix macvim)/MacVim.app/Contents/bin/vim"
    fi
    
    mkdir -p $VIMDIR/undo
    mkdir -p $VIMDIR/backup
    mkdir -p $VIMDIR/swap
    
    # Install Vundle Package Manager
    git clone https://github.com/VundleVim/Vundle.vim.git $VIMDIR/bundle/Vundle.vim
    
    vim +PluginInstall +qall
    
    # Manually Install YouCompleteMe -- may need to do an offline install after bootstrap (finicky)
    cd $VIMDIR/bundle/youcompleteme
    $CONDA/bin/python3 ./install.py
    CD $DOTFILES
}
setupVim

#source $HOME/.macos
