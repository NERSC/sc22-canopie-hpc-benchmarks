WIP

## Building Docker Image

1. checkout submodule (or public repo)
2. `git apply <patch>`
3. `docker build ...` (or `cd LBNL; make`)

## testing with small configs

1. use those small job configs
1. see README in the repo
1. `export CONTAINER_RUNTIME=whatever`
1. `export DATADIR=<where the data is>`
1. `source config`
1. `sbatch ..........`

## run the scaling

1. `./scaling.sh`

