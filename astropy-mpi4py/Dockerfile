FROM ubuntu:18.04
LABEL maintainer="Rollin Thomas <rcthomas@lbl.gov>"
WORKDIR /opt

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8

RUN \
    apt-get update          &&  \
    apt-get upgrade --yes   &&  \
    apt-get install --yes       \
        build-essential         \
        gfortran                \
        git                     \
        python3-dev             \
        python3-pip             \
        python3-setuptools      \
        tzdata                  \
        vim                     \
        wget                &&  \
    rm -rf /var/lib/apt/lists/*

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

RUN pip3 install --no-binary=mpi4py mpi4py

RUN \
    pip3 install --no-cache-dir \
        astropy

ENV XDG_CACHE_HOME=/opt/cache
RUN mkdir -p $XDG_CACHE_HOME/astropy

ENV XDG_CONFIG_HOME=/opt/config
RUN mkdir -p $XDG_CONFIG_HOME/astropy

RUN python3 -c "import astropy"

ADD . /tmp/build
RUN \
    cd /tmp/build               &&  \
    python3 setup.py install    &&  \
    cd /tmp                     &&  \
    rm -rf build

RUN /sbin/ldconfig

