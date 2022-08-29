FROM nersc/ubuntu-mpi:18.04

RUN \
    PATH=/sbin:/usr/sbin:$PATH && \
    apt-get -y update && \
    apt-get -y install git python-dev libz-dev gawk

RUN git clone https://github.com/LLNL/pynamic

RUN \
    cd pynamic/pynamic-pyMPI-2.6a1/ && \
    sed -i 's|bin/sh|bin/bash|' get-symtab-sizes && \
    PATH=`pwd`:$PATH && \
    ./config_pynamic.py 900 1250 -n 15 -j 32 -i /usr/include/python2.7/

ENV PATH=/pynamic/pynamic-pyMPI-2.6a1:$PATH

RUN \
    echo "/pynamic/pynamic-pyMPI-2.6a1" > /etc/ld.so.conf.d/pynamic.conf && \
   /sbin/ldconfig
