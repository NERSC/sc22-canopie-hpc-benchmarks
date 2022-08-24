# example-scaling-snapC Benchmark

This benchmark is based on the original one used for Rahul Gayatri's 2021 Gordon Bell runs:

`https://gitlab.com/NESAP/EXAALT/example-scaling-snapc`

Many thanks to Rahul for his invaluable expertise and help with these benchmarks.

## Adapting for container benchmarking

We did some editing to prepare these
runs for Podman, Shifter, and baremetal benchmarking for CANOPIE-HPC 2022.

## `build-exaalt-baremetal.sh`

Based on Rahul's original at 

`https://gitlab.com/NERSC/nersc-user-software/-/blob/rgayatri/build_scripts/manual-build-scripts/lammps/build_lammps_pm.sh`

Very lightly modified (build location changed). 

## `submit.sh`

Used to submit a scaling run of jobs.

User should specify only one kind of benchmark. This will be exported
and passed into the child processes and used to name the temp directory
for the job. 

The same script can be used to launch all 4 types of benchmarks. 

## `run_pm.sub`

Rahul's original `run_pm.sub` has been modified for all
three kinds of benchmarks. The baremetal case required very minor
modification (just pointing to new build location on /global/common
and using the additional benchmark-named temporary directory.

`run_shifter.sub` runs the Shifter version. It requests the right image
`registry.nersc.gov/das/exaalt:benchmark` and also uses the default `mpich`
module. The strange CUDA-aware MPI behavior means we need our `wrap.sh`
script to use `LD_PRELOAD` to link to the GTL libraries needed for CUDA-aware
MPICH.

`run_podman.sub` runs the Podman run configuration in which each MPI process
starts its own copy of Podman and all of the associated filesystem clients, etc.
It runs a series of scripts and executables located on a shared GPFS filesystem.
Both podman benchmarks use the same `registry.nersc.gov/das/exaalt:benchmark`
image which has been pulled and squashed in advance. 

`run_podman_exec.sub` runs the more sophisticated Podman run + Podman exec
configuration. In this mode, we first start one Podman container per node
with `sleep infinity`, then detach from it, and connect to it with one
`podman exec` process for each MPI process. This allows each process to share
the same instance of the Podman container and all of its associated resources.
Additionally, in this mode Podman reads from a set of files that have been
staged into the fast `/tmp` local memory of each node. 

Finally, we have added a somewhat poorly named `wrap.sh` to `files`. This is for the
Shifter benchmark and handles the `LD_PRELOAD` currently needed for
CUDA-aware MPICH to work correctly with the Shifter ABI swap.

## Results

All output files used to generate the plots shown in the paper are in the 
`results` folder.

## Plots

The scripts used to plot the data and the figures themselves are in the
`plots` folder.

