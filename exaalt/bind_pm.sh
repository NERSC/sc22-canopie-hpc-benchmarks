#!/bin/bash
#numactl --cpunodebind=$SLURM_LOCALID --membind=$SLURM_LOCALID $*
lrank=$(($SLURM_LOCALID % 4))

export MPICH_OFI_NIC_POLICY GPU
APP="$*"
echo $APP

case ${lrank} in
 [0])
 #numactl --physcpubind=0-15,64-79 --membind=0 $APP
 numactl --physcpubind=0-15 --membind=0 $APP
 ;;

 [1])
 #numactl --physcpubind=16-31,80-95 --membind=1 $APP
 numactl --physcpubind=16-31 --membind=1 $APP
 ;;

 [2])
 #numactl --physcpubind=32-47,96-111 --membind=2 $APP
 numactl --physcpubind=32-47 --membind=2 $APP
 ;;

 [3])
 numactl --physcpubind=48-63,112-127 --membind=3 $APP
 ;;
esac
