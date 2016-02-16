#!/bin/sh

git pull origin master;

function doIt() {
    rsync —exclude “.git/“ —exclude “.gitsubmodules” \
        —exclude “./zsh” -exclude “./conda” \
        —exclude “.DS_Store” —exclude “*.sh” \ —exclude “./fonts” \
        —exclude “README.md” —exclude “LICENSE” -avh —no-perms . ~;

    mkdir ~/Developer
    mkdir ~/Remotes
    source ~/.zshrc;
}

if [ “$1”==“—force” -o “$1”==“-f” ]; then
    doIt;
else
    echo “This may overwrite existing files in your home directory. Are you sure? (y/n) “;
    read REPLY;
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt;
    fi;
fi;
unset doIt;