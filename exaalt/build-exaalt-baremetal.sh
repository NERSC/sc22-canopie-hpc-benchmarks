#!/bin/bash

set -xe


module rm darshan
module rm xalt

module load PrgEnv-gnu
module load cudatoolkit
module load craype-accel-nvidia80

threads=64

HOME=/global/common/software/das/stephey/exaalt
SRC=${HOME}/mainline_lammps
INSTALL_PREFIX="${HOME}/mainline_lammps_install"
export CRAYPE_LINK_TYPE=dynamic

export MPICH_GPU_SUPPORT_ENABLED=1

# Check if I am using my latest cmake
echo $(cmake --version)

# git clone lammps
if [ ! -d ${SRC} ]; then
  git clone https://github.com/lammps/lammps.git ${SRC}
  cd ${SRC}
  git pull
  cd ..
fi
cd ${SRC}

if [ ! -d build ]; then
    mkdir build
fi
cd build
rm -rf *

cmake \
-D CMAKE_BUILD_TYPE=Release \
-D CMAKE_Fortran_COMPILER=ftn \
-D CMAKE_C_COMPILER=cc \
-D CMAKE_CXX_COMPILER=CC \
-D CMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
-D LAMMPS_EXCEPTIONS=on \
-D BUILD_SHARED_LIBS=on \
-D PKG_KOKKOS=yes -D Kokkos_ARCH_AMPERE80=ON -D Kokkos_ENABLE_CUDA=yes \
-D PKG_MANYBODY=yes \
-D PKG_REPLICA=yes \
-D PKG_ML-SNAP=yes \
-D PKG_EXTRA-FIX=yes \
-D PKG_MPIIO=yes \
../cmake

make -j${threads}
make install -j${threads}

cd ${HOME}
rm -rf ${SRC}

