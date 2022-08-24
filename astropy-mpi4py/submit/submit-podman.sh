#!/bin/bash
#SBATCH --account=nstaff
#SBATCH --constraint=cpu
#SBATCH --job-name=astropyle-podman
#SBATCH --output=/pscratch/sd/s/stephey/astropyle/submit/output/astropyle-podman-%j.out
#SBATCH --time=10
##SBATCH --reservation=podman_cpu_4
#SBATCH --qos=regular

module purge

export IMAGE=registry.nersc.gov/das/astropyle:benchmark

/global/common/shared/das/podman.sync/bin/localize.sh
PATH=/tmp/$(id -u)_hpc/podman/bin/:/usr/bin:/bin
unset LD_LIBRARY_PATH

which podman

echo "running astropyle podman nodes $SLURM_JOB_NUM_NODES"

export PODMAN_FLAGS="--env PMI_MMAP_SYNC_WAIT_TIME=600"
export PODMAN_EXEC_FLAGS="--env PMI_MMAP_SYNC_WAIT_TIME=600"

echo "first run"

HOME=/tmp /usr/bin/time -f "Time: %E" srun --cpu_bind=cores podman-mpi-exec python3 -m astropyle $(date +%s)

sleep 5

echo "second run"

HOME=/tmp /usr/bin/time -f "Time: %E" srun --cpu_bind=cores podman-mpi-exec python3 -m astropyle $(date +%s)

echo "done"
