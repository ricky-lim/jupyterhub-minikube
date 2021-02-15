# Jupyterhub-minikube

Jupyterhub with minikube

## Requirements

- `make`
- `kubectl`
- `kubectx`
- `kubens`

## Deployment `make`

```bash
# Configure to use minikube docker daemon
eval $(minikube docker-env)

# Setup minikube (if not yet available in your system)
make setup

# Initialize environment
make init

# Create docker images for hub and singleuser
make hub
make singleuser

# Install jupyterhub
make install

# Port-forwarding
make port-forward

# Upgrade jupyterhub as the configs/config-minikube.yaml changed
make upgrade

# Uninstall jupyterhub
make uninstall
```

