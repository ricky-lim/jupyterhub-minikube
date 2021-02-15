#!/bin/bash
set -e

# Setup for jupyter lab
# e.g bash jupyterlab_setup.sh <env_name1> <env_name2> ...
CONDA_PREFIX="${CONDA_PREFIX:-/opt/conda}"

for env in "$@"
do

  # Create ipykernel
  mamba run -n "$env" bash -c \
    "python -m ipykernel install --prefix $CONDA_PREFIX \
    --name $env --display-name $env"

done
