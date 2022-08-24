#!/bin/bash

#rahul thinks a problem size of nrep up to 28 will probably run on 1024 nodes
#these loops have to be run one at a time. i think jobs may collide? at least
#the temp submit script may be a problem

# 28 - 1 billion
# 75 - 20 billion
#for nrep in 2 3 4 6 8 13 16 28 75 #32 45 75
#i#for nrep in 28

nsize=28
declare -a nodes=("128")

#options are baremetal, shifter, podman
#export benchmark='baremetal'
#export benchmark='shifter'
export benchmark='podman-exec'
#export benchmark='podman'

echo "requested benchmark type $benchmark"

if [ $benchmark == 'baremetal' ]; then
    for nnodes in "${nodes[@]}"
    do
        for nrep in $nsize
        do
            sed 's/_NTASKS_/'$(( $nnodes*4 ))'/g' run_baremetal.sub> temp.sub.$nrep.$nnodes
            sed -i 's/_NREP_/'$(( $nrep ))'/g' temp.sub.$nrep.$nnodes
            sbatch temp.sub.$nrep.$nnodes
        done 
    done 
    echo "submitted baremetal"  

elif [ $benchmark == 'shifter' ]; then
    for nnodes in "${nodes[@]}"
    do
        for nrep in $nsize
        do
            sed 's/_NTASKS_/'$(( $nnodes*4 ))'/g' run_shifter.sub> temp.sub.$nrep.$nnodes
            sed -i 's/_NREP_/'$(( $nrep ))'/g' temp.sub.$nrep.$nnodes
            sbatch temp.sub.$nrep.$nnodes
        done
    done
    echo "submitted shifter"

elif [ $benchmark == 'podman' ]; then
    for nnodes in "${nodes[@]}"
    do
        for nrep in $nsize
        do
            sed 's/_NTASKS_/'$(( $nnodes*4 ))'/g' run_podman.sub> temp.sub.$nrep.$nnodes
            sed -i 's/_NREP_/'$(( $nrep ))'/g' temp.sub.$nrep.$nnodes
            sbatch temp.sub.$nrep.$nnodes
        done
    done
    echo "submitted podman"
elif [ $benchmark == 'podman-exec' ]; then
    for nnodes in "${nodes[@]}"
    do
        for nrep in $nsize
        do
            sed 's/_NTASKS_/'$(( $nnodes*4 ))'/g' run_podman_exec.sub> temp.sub.$nrep.$nnodes
            sed -i 's/_NREP_/'$(( $nrep ))'/g' temp.sub.$nrep.$nnodes
            sbatch temp.sub.$nrep.$nnodes
        done
    done
    echo "submitted podman exec"
else
    :
fi    
