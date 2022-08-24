#!/bin/bash

LD_PRELOAD=/opt/udiImage/modules/mpich/libmpi_gtl_cuda.so.0 $@
