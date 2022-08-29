#!/bin/bash

# Three of each
CYCLES=3
# EXTRA="-q debug"
EXTRA="-q regular -C cpu --reservation podman_cpu_4"

# 64 per node
let TPN=64

for N in 128 256 ; do # 256 512
    let NN=$N*$TPN
    echo $NN
    for i in $(seq 1 ${CYCLES}) ; do
        sbatch $EXTRA -N $N -n $NN -o scale-podman-exec-$NN-%j.out pynamic-podman-exec.sl
        sbatch $EXTRA -N $N -n $NN -o scale-podman-hpc-$NN-%j.out pynamic-podman-hpc.sl
        sbatch $EXTRA -N $N -n $NN -o scale-shifter-$NN-%j.out pynamic-shifter.sl
        sbatch $EXTRA -N $N -n $NN -o scale-baremetal-$NN-%j.out pynamic-baremetal.sl
    done
done
