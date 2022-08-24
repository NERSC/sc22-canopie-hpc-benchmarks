#!/bin/bash
#SBATCH --account=nstaff
#SBATCH --constraint=cpu
#SBATCH --cpus-per-task=2
#SBATCH --job-name=astropyle-baremetal
#SBATCH --nodes=100
#SBATCH --ntasks-per-node=128
#SBATCH --output=/pscratch/sd/s/stephey/astropyle/submit/output/astropyle-baremetal-%j.out
#SBATCH --time=15
##SBATCH --reservation=podman_cpu_1
#SBATCH --qos=regular

module unload darshan

install_path=/global/common/shared/das/stephey/astropyle

export PMI_MMAP_SYNC_WAIT_TIME=600

export XDG_CACHE_HOME=$install_path/cache
export XDG_CONFIG_HOME=$install_path/config
export PATH=$install_path/env/bin:$PATH
unset PYTHONPATH

echo "running astropyle baremetal nodes $SLURM_JOB_NUM_NODES"

echo "first run (no cache)"

time srun --cpu_bind=cores python -m astropyle $(date +%s)

sleep 5

echo "second run (cached)"

time srun --cpu_bind=cores python -m astropyle $(date +%s)

echo "done"
