# Dotfiles
This is a repository of Dotfiles that contain system settings on Unix/Linux-based machines.


## Overview
This repository is primarily geared for MacOS. The repo may be adapted for use on Linux, but mileage may vary. All in all, *Dotfiles* will install MacOS software used on a day-to-day basis, will symlink centralized configurations for software and system settings, and will setup the Hoth research environment. 


## Installation
0. Install XCode in the App Store.
1. Ensure there is active git functionality on the machine you wish to use this repo.
2. Run git script: `git clone https://github.com/akhambhati/Dotfiles.git ~/Dotfiles`
  
   *Note: you should clone as HTTPS, as SSH will be setup by the Dotfile repo*

3. Manual review of aliases, paths, exports, and software based on target OS. 
4. Run install script: `sh ~/Dotfiles/bootstrap.sh`


## Basic Operations
Running `bootstrap.sh` will perform the following operations (in order):
1. `initialUpdate()`    : Update MacOS (if applicable) with the latest OS version and software, and install XCode CLI.
2. `setupHoth()`        : Setup canonical folder structure for the Hoth research system.
3. `setupSymlinks()`    : Automatically determine which folders need to be symlinked to the `$HOME` directory.
4. `setupAnaconda()`    : Setup customized Hoth conda environment (python 3) with custom environment.yml.
5. `setupCantina()`     : Install Homebrew and Cask; Update software list and install.
6. `setupZSH()`         : Install the ZSH Shell and the Antigen (packages will install upon first shell run).
7. `setupTerm2()`       : Install the color theme and update some default configurations.
8. `setupVim()`         : Link to Brew version of MacVim (for YouCompleteMe) and install Vundle (packages will install upon first vim run).


## Repository Structure
### Root folders
All folders and/or files that need to be symlinked to $HOME must be stored in a nested hierarchy structure. The root folders (e.g. `./shell`) in this repository are simply for readability and organization. The second-level folders and files contained within the root folders are automatically parsed and iteratively symlinked to $HOME.
### Cfg folder
Any files and folders contained within `./cfg` will **__not__** be symlinked. This provides an avenue to version control auxilliary settings that are referenced during/after installation, but are not used by the system or system applications.


## Idiosyncrasies
### Linux
#### Homebrew
The *Dotfiles* system uses Homebrew and Cask as the principal package manager for machines running MacOS. For Linux machines, package managers are distribution specific, which is difficult to support widely. In the future, I may adopt a Brewfile-like system for package managers that are most commonly used, but *this feature does not exist at the moment*. Therefore, for Linux installs I can only suggest a manual approach using pre-compiled source or DEB-type packages.
