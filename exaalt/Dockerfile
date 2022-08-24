FROM nvcr.io/nvidia/cuda:11.5.1-devel-ubuntu20.04

# set working-dir as /opt
WORKDIR /opt

## Set non-interactive debian mode for interactive inputs
ENV DEBIAN_FRONTEND=noninteractive

# GNU compiler and cmake/3.21.3
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    g++ \
    gcc \
    git \
    libtool \
    gfortran \
    make \
    tar \
    autoconf \
    automake \
    valgrind \
    libssl-dev \
    wget && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/tmp/cmake && cd /var/tmp/cmake && wget https://github.com/Kitware/CMake/releases/download/v3.21.3/cmake-3.21.3.tar.gz && tar -xvzf cmake-3.21.3.tar.gz && cd  cmake-3.21.3/ && ./bootstrap && make && make install && rm -rf /var/tmp/cmake

# GDRCOPY version 2.1
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        make \
        wget && \
    rm -rf /var/lib/apt/lists/*
RUN mkdir -p /var/tmp && wget -q -nc --no-check-certificate -P /var/tmp https://github.com/NVIDIA/gdrcopy/archive/v2.1.tar.gz && \
    mkdir -p /var/tmp && tar -x -f /var/tmp/v2.1.tar.gz -C /var/tmp -z && \
    cd /var/tmp/gdrcopy-2.1 && \
    mkdir -p /usr/local/gdrcopy/include /usr/local/gdrcopy/lib64 && \
    make PREFIX=/usr/local/gdrcopy lib lib_install && \
    echo "/usr/local/gdrcopy/lib64" >> /etc/ld.so.conf.d/hpccm.conf && ldconfig && \
    rm -rf /var/tmp/gdrcopy-2.1 /var/tmp/v2.1.tar.gz
ENV CPATH=/usr/local/gdrcopy/include:$CPATH \
    LIBRARY_PATH=/usr/local/gdrcopy/lib64:$LIBRARY_PATH

# MPICH to be swapped out later for Cray MPICH
ARG mpich=3.3
ARG mpich_prefix=mpich-$mpich

RUN \
    wget https://www.mpich.org/static/downloads/$mpich/$mpich_prefix.tar.gz && \
    tar xvzf $mpich_prefix.tar.gz                                           && \
    cd $mpich_prefix                                                        && \
    ./configure                                                             && \
    make -j 4                                                               && \
    make install                                                            && \
    make clean                                                              && \
    cd ..                                                                   && \
    rm -rf $mpich_prefix

RUN /sbin/ldconfig

## variables for paths
ARG LAMMPS_PATH=/opt/LAMMPS
ARG LAMMPS_INSTALL=/opt/LAMMPS_INSTALL

## Enter LAMMPS_PATH and download lammps stable version from 
RUN mkdir $LAMMPS_PATH && cd $LAMMPS_PATH && git clone https://github.com/lammps/lammps.git && \
	cd lammps  && mkdir build_snap && cd build_snap && cmake \
	-D CMAKE_CXX_COMPILER=$LAMMPS_PATH/lammps/lib/kokkos/bin/nvcc_wrapper \
	-D CMAKE_INSTALL_PREFIX=$LAMMPS_INSTALL \
	-D CMAKE_POSITION_INDEPENDENT_CODE=ON \
	-D CMAKE_EXE_LINKER_FLAGS="-dynamic" \
	-D CMAKE_VERBOSE_MAKEFILE=FALSE \
	-D BUILD_SHARED_LIBS=no \
	-D PKG_GPU=no \
	-D PKG_ML-SNAP=yes \
	-D PKG_KOKKOS=yes -D Kokkos_ARCH_AMPERE80=ON -D Kokkos_ENABLE_CUDA=yes \
	-D PKG_MANYBODY=ON -D PKG_MOLECULE=ON -D PKG_KSPACE=ON -D PKG_REPLICA=ON -D PKG_ASPHERE=ON -D PKG_RIGID=ON \
	-D MPI_C_COMPILER=mpicc \
	-D MPI_CXX_COMPILER=mpicxx \
	$LAMMPS_PATH/lammps/cmake && make -j16 && make install && rm -rf $LAMMPS_PATH

## Set paths to LAMMPS binary
ENV PATH=$PATH:$LAMMPS_INSTALL/bin
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$LAMMPS_INSTALL/lib64

#Set path we'll use later for GTL (cuda-aware mpi)
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tmp
