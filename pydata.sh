#!/usr/bin/env zsh

# Removed user's cached credentials
# This script might be run with .dots, which uses elevated privileges
sudo -K

# Install the miniconda environment
curl -o ./conda/conda_install.sh https://repo.continuum.io/miniconda/Miniconda-latest-MacOSX-x86_64.sh
chmod ugo+x ./conda/conda_install.sh
./conda/conda_install.sh -p $CONDA

# Create the cb environment
conda env create -f ./conda/environment.yml

# Remove the miniconda installer
rm -r conda/conda_install.sh



