#!/bin/bash

CYCLES=3
# Three of each
# EXTRA="--reservation podman-eval-gpu -q resv"
EXTRA="-q debug"
EXTRA="-q regular -C cpu --reservation podman_cpu_1"
EXTRA="-q regular -C cpu"

# 64 per node
let TPN=64

export PMI_MMAP_SYNC_WAIT_TIME=300
export IMAGE=scanon/pynamic:2.6a1
export COMM="/pynamic/pynamic-pyMPI-2.6a1/pyMPI /pynamic/pynamic-pyMPI-2.6a1/pynamic_driver.py"

for N in 1 2 4 8 16 32 64 128; do 
    for i in $(seq 1 ${CYCLES}) ; do
         echo "RUN: Podman - container per task - $N $i"
         /usr/bin/time -f "Time: %E" \
               srun -n $N podman-hpc.py run --rm --mpi $IMAGE $COMM

         echo "RUN: Podman - exec mode - $N $i"
         /usr/bin/time -f "Time: %E" srun -n $N podman-mpi-exec $COMM

         echo "RUN: Shifter - $N $i"
         /usr/bin/time -f "Time: %E" srun -n $N shifter --module mpich $COMM
    done
done
