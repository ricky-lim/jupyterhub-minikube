#!/bin/bash
set -e

jupyter labextension install --no-build \
    @jupyter-widgets/jupyterlab-manager \
    @jupyter-voila/jupyterlab-preview \
    bqplot \
    ipyfetch \
    jupyter-vuetify \
    jupyter-cytoscape \
    jupyterlab-jupytext@1.2.2 \
    jupyter-matplotlib \
    jupyterlab_templates

jupyter lab build