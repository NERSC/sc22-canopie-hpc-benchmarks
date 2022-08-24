# astropy + mpi4py import benchmark

This benchmark is lightly adapted from one developed
by Rollin Thomas called `astropyle`. Many thanks to 
Rollin for sharing this benchmark with us for our study.

The benchmark itself is relatively simple- it imports
the Python library `astropy` inside of an `mpi4py` job. 
`astropy` was chosen since it's a relatively large Python
library with a comparatively long import time. 

Since this benchmark is
meta-data heavy, it's well-suited for measuring any potential
benefits that may come from using a squash-mounted image
via a container.

## Sumitting jobs

All scripts used to submit the jobs in this study are located in the 
`submit` folder. These are all modified from the original `astropyle`
benchmark.

`submit-baremetal.sh` runs the astropyle benchmark located on our
shared GPFS filesystem.

`submit-shifter.sh` runs the benchmark via Shifter using the 
`registry.nersc.gov/das/astropyle:benchmark`. 

`submit-podman.sh` runs the benchmark via Podman in the
`podman run` + `podman exec` mode that allows all MPI processes
on a node to be run within the same Podman container. It uses
the same `registry.nersc.gov/das/astropyle:benchmark` that has been pulled
and squashed in advance. It is also
using several scripts/excutables that have been staged into the
fast `/tmp` local storage on each node.

`submit-scan.sh` is a convieience script for launching the benchmarks
in this study with an array of MPI tasks per node and cpus per task.

## Results

All output files used to generate the plots shown in the paper are in the 
`results` folder.

## Plots

The scripts used to plot the data and the figures themselves are in the
`plots` folder.
