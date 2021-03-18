ARG BASE_IMAGE=jupyterhub/k8s-hub:0.11.1
FROM $BASE_IMAGE

USER root
RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install cdsdashboards==0.5.0-beta2

USER ${NB_USER}