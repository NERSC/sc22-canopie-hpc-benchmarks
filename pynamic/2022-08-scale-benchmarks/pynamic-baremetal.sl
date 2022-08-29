#!/bin/bash
#SBATCH -N 512
#SBATCH -C cpu
#SBATCH -t 30:00
#SBATCH -J pynamic-baremetal
#SBATCH -o pynamic-baremetal-%j.out

export PMI_MMAP_SYNC_WAIT_TIME=300
echo "Baremetal"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/shifter/mpich-1.1/:/usr/lib/shifter/mpich-1.1/dep/
/usr/bin/time -f "Time: %E" srun $SCRATCH/pynamic/pynamic-pyMPI-2.6a1/pyMPI $SCRATCH/pynamic/pynamic-pyMPI-2.6a1/pynamic_driver.py

echo "Cached"
/usr/bin/time -f "Time: %E" srun $SCRATCH/pynamic/pynamic-pyMPI-2.6a1/pyMPI $SCRATCH/pynamic/pynamic-pyMPI-2.6a1/pynamic_driver.py
