#!/usr/bin/env zsh

function runDots() {
    # Ask for the administrator password upfront
    sudo -v

    # Keep-alive: update existing `sudo` time stamp until the script has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    # Run sections based on command line arguments
    for ARG in "$@"
    do
        if [ $ARG == “bootstrap” ] || [ $ARG == “all” ]; then
            echo “”
            echo “—————————————————————————————”
            echo “Syncing the Dotfiles repo to your local machine.”
            echo “—————————————————————————————”
            echo “”
            sh bootstrap.sh
        fi
        if [ $ARG == “osxprep” ] || [ $ARG == “all” ]; then
            echo “”
            echo “—————————————————————————————”
            echo “Updating OS X and installing Xcode command line tools.”
            echo “—————————————————————————————”
            echo “”
            sh osxprep.sh
        fi
        if [ $ARG == “brew” ] || [ $ARG == “all” ]; then
            # Run the brew.sh Script
            # For a full listing of installed formulae and apps, refer to
            # the commented brew.sh source file directly and tweak it to
            # suit your needs.
            echo “”
            echo “—————————————————————————————”
            echo “Installing Homebrew along with some common formulae and apps.”
            echo “This might awhile to complete, as some formulae need to be installed from source.”
            echo “—————————————————————————————”
            echo “”
            sh brew.sh
        fi
        if [ $ARG == “pydata” ] || [ $ARG == “all” ]; then
            # Run the pydata.sh Script
            echo “”
            echo “—————————————————————————————”
            echo “Setting up Python data development environment.”
            echo “—————————————————————————————”
            echo “”
            sh pydata.sh
        fi
    done

    echo “—————————————————————————————”
    echo “Completed running .dots, restart your computer to ensure all updates take effect.”
    echo “—————————————————————————————”
}

if [ $SHELL = /bin/bash ]; then
    echo “Changing shell to ZSH…”
    chsh -s /bin/zsh
    exec su - $USER
fi

echo “This script may overwrite existing files in your home directory. Are you sure?”
read REPLY
if [[ $REPLY =~ ^[Yy]$ ]]; then
    runDots “$@”
fi;

unset runDots;