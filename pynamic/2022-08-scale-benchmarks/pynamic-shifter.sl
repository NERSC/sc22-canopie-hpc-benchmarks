#!/bin/bash
#SBATCH -N 512
#SBATCH -C cpu
#SBATCH -t 30:00
#SBATCH -J pynamic-shifter
#SBATCH -o pynamic-shifter-%j.out
#SBATCH --image=scanon/pynamic:2.6a1 

unset XDG_RUNTIME_DIR
export PMI_MMAP_SYNC_WAIT_TIME=300
PATH=/global/common/shared/das/podman/bin/:$PATH

echo "Shifter"
/usr/bin/time -f "Time: %E" srun shifter  \
       /pynamic/pynamic-pyMPI-2.6a1/pyMPI /pynamic/pynamic-pyMPI-2.6a1/pynamic_driver.py

echo "Cached"
/usr/bin/time -f "Time: %E" srun shifter  \
       /pynamic/pynamic-pyMPI-2.6a1/pyMPI /pynamic/pynamic-pyMPI-2.6a1/pynamic_driver.py
