#!/bin/bash
#SBATCH -N 128 -n 2048
#SBATCH -C cpu -A nstaff
#SBATCH -t 30:00
#SBATCH -J pynamic-podman-hpc
#SBATCH -o pynamic-podman-hpc-%j.out

/global/common/shared/das/podman.sync/bin/localize.sh

PATH=/tmp/$(id -u)_hpc/podman/bin/:/usr/bin:/bin
unset LD_LIBRARY_PATH


export PMI_MMAP_SYNC_WAIT_TIME=300
export IMAGE=scanon/pynamic:2.6a1 
export COMM="/pynamic/pynamic-pyMPI-2.6a1/pyMPI /pynamic/pynamic-pyMPI-2.6a1/pynamic_driver.py"


srun -N $SLURM_NNODES -n $SLURM_NNODES  podman-hpc2.py rm --force --all --log-level fatal > /dev/null 2>&1
srun -O --overlap -N $SLURM_NNODES -n $SLURM_NNODES  podman-hpc2.py run --name hpc --rm --mpi --gpu $PODMAN_FLAGS --log-level fatal \
           $IMAGE sleep infinity &

echo "Waiting"
sleep 10

echo "Podman"
HOME=/tmp /usr/bin/time -f "Time: %E" srun -N $SLURM_NNODES -n $SLURM_NPROCS -O --overlap podman-hpc2.py exec \
       -e "PALS_*" -e "PMI_*" -e "SLURM_*" \
       $PODMAN_EXEC_FLAGS \
       hpc $COMM
       
sleep 20
echo "Cached"
HOME=/tmp /usr/bin/time -f "Time: %E" srun -O --overlap podman-hpc2.py exec \
       -e "PALS_*" -e "PMI_*" -e "SLURM_*" \
       $PODMAN_EXEC_FLAGS \
       hpc $COMM
