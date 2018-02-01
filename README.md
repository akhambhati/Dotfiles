# Dotfiles
This is a repository of Dotfiles that contain system settings on Unix/Linux-based machines.


## Overview
This repository is primarily geared for MacOS. The repo may be adapted for use on Linux, but mileage may vary. All in all, *Dotfiles* will install MacOS software used on a day-to-day basis, will symlink centralized configurations for software and system settings, and will setup the Hoth research environment. 


## Installation
0. Install XCode in the App Store.
1. First ensure there is active git functionality on the machine you wish to use this repo.
2. Run git script: `git clone https://github.com/akhambhati/Dotfiles.git ~/Dotfiles`
  
   *Note: you should clone as HTTPS, as SSH will be setup by the Dotfile repo*

3. Manual review of aliases, paths, exports, and software based on target OS. 
3. Run install script: `sh ~/Dotfiles/bootstrap.sh`


## Basic Operations
Running `bootstrap.sh` will perform the following operations (in order):
1. `initialUpdate()`    : Update MacOS (if applicable) with the latest OS version and software, and install XCode CLI.
2. `setupHoth()`        : Setup canonical folder structure for the Hoth research system



This repository follows acontents in `./cfg` are non-symlinked 
