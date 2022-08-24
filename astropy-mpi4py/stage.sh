#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

install_path=/global/common/shared/das/stephey/astropyle

# Prepare install path

rm -rf $install_path
mkdir -p $install_path

# Install Miniconda Python 3

install_prefix=$install_path/env
miniconda_installer=Miniconda3-latest-Linux-x86_64.sh
wget https://repo.anaconda.com/miniconda/$miniconda_installer
/bin/sh $miniconda_installer -b -p $install_prefix
rm -rf $miniconda_installer

# Update conda, install astropy and dependenencies

export PATH=$install_prefix/bin:$PATH
conda update --yes conda
conda clean --yes --all
pip install --no-cache-dir astropy

# Prepopulate AstroPy configuration file

export XDG_CACHE_HOME=$install_path/cache
mkdir -p $XDG_CACHE_HOME/astropy

export XDG_CONFIG_HOME=$install_path/config
mkdir -p $XDG_CONFIG_HOME/astropy

python -c "import astropy"

# Install mpi4py

mpi4py=mpi4py-3.1.3
mpi4py_tgz=$mpi4py.tar.gz
wget https://bitbucket.org/mpi4py/mpi4py/downloads/$mpi4py_tgz
tar zxvf $mpi4py_tgz
cd $mpi4py
python setup.py build --mpicc="$(which cc) -shared"
python setup.py install
cd ..
rm -rf $mpi4py $mpi4py_tgz

# Install the AstroPyle package

python setup.py install
rm -rf build dist astropyle.egg-info
