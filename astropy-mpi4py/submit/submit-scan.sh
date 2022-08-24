#!/bin/bash

#let's scan over number of nodes
#number of ranks per node
#shifter, podman, baremetal

declare -a nnodes=("128")  
declare -a ntaskspernode=("32" "64" "128")
declare -a framework=("baremetal" "shifter" "podman")

## now loop through the above array
for i in "${nnodes[@]}"; do
  for j in "${ntaskspernode[@]}"; do
    for k in "${framework[@]}"; do
	ncpus=$((256 / $j))
        sbatch -N $i --ntasks-per-node=$j --cpus-per-task=$ncpus submit-$k.sh 
	echo "submitted $k $i nodes $j tasks per node $ncpus cpus per task"
    done
  done    
done
