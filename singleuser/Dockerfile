ARG TAG=1.2
ARG BASE_REPO=jupyterhub/singleuser

FROM $BASE_REPO:$TAG

USER root
RUN apt-get -y update && apt-get install -y git vim build-essential

# Add conda environment
ADD conda-env conda-env
RUN fix-permissions conda-env
USER $NB_UID
RUN conda env update --name base --file conda-env/base.yaml

# Set conda environment
RUN conda init bash
USER root
RUN mkdir -p /etc/conda && cp conda-env/.condarc /etc/conda/.condarc && \
    cp conda-env/conda-init.sh /etc/profile.d/conda-init.sh

# Fix permissions on /etc/jupyter as root
USER root
RUN fix-permissions /etc/jupyter/
USER $NB_UID
