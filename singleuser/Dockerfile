ARG TAG=1.2
ARG BASE_REPO=jupyterhub/singleuser

FROM $BASE_REPO:$TAG

USER root
RUN apt-get -y update && apt-get install -y git vim build-essential

# Add conda environment
ADD conda-env conda-env
RUN fix-permissions conda-env
USER $NB_UID
RUN conda install -c conda-forge mamba=0.5.3
RUN mamba env update --name base --file conda-env/base.yaml
RUN bash conda-env/create_ipykernel.sh base
RUN bash conda-env/setup_jupyterlab.sh
ENV JUPYTER_PATH=/opt/conda/share/jupyter

# Add jupyterlab_templates
# More info: 'https://github.com/jpmorganchase/jupyterlab_templates'
ARG JUPYTERLAB_TEMPLATE=/opt/conda/share/jupyter/notebook_templates
RUN mkdir -p $JUPYTERLAB_TEMPLATE && \
    cp -r conda-env/jupyterlab-templates/* $JUPYTERLAB_TEMPLATE

# Set jupyter config
COPY jupyter_notebook_config_singleuser.py /etc/jupyter/
RUN cat /etc/jupyter/jupyter_notebook_config_singleuser.py >> \
    /etc/jupyter/jupyter_notebook_config.py
RUN rm /etc/jupyter/jupyter_notebook_config_singleuser.py

# Set the template for voila viewer, i.e voila-dashboards/jupyterlab-preview
ENV JUPYTER_PATH=/opt/conda/share/jupyter

RUN pip install jhsingle-native-proxy==0.7.0

# Set conda environment
RUN conda init bash
USER root
RUN mkdir -p /etc/conda && cp conda-env/.condarc /etc/conda/.condarc && \
    cp conda-env/conda-init.sh /etc/profile.d/conda-init.sh

# Add UI-template
COPY templates/ /opt/conda/share/jupyter/lab/static/

# Fix permissions on /etc/jupyter as root
USER root
RUN fix-permissions /etc/jupyter/
USER $NB_UID
