#!/bin/bash
#SBATCH --account=nstaff
#SBATCH --constraint=cpu
#SBATCH --job-name=astropyle-shifter
#SBATCH --output=/pscratch/sd/s/stephey/astropyle/submit/output/astropyle-shifter-%j.out
#SBATCH --time=10
#SBATCH --image=registry.nersc.gov/das/astropyle:benchmark
##SBATCH --reservation=podman_cpu_4
#SBATCH --qos=regular

module purge

export PMI_MMAP_SYNC_WAIT_TIME=600

unset PYTHONPATH

echo "running astropyle shifter nodes $SLURM_JOB_NUM_NODES"

echo "first run (no cache)"

time srun --cpu_bind=cores shifter python3 -u -m astropyle $(date +%s)

sleep 5

echo "second run (cached)"

time srun --cpu_bind=cores shifter python3 -u -m astropyle $(date +%s)

echo "done"
