# Jupyterhub-minikube

Jupyterhub with minikube

## Requirements

- `make`
- `kubectx` and `kubens`: https://github.com/ahmetb/kubectx

## Deployment `make`

```bash
# Configure to use minikube docker daemon, recommend to put this into `.envrc`
eval $(minikube docker-env)

# Setup minikube (if not yet available in your system)
make setup

# Initialize environment
make init

# Install jupyterhub
make install

# Port-forwarding, when pod is ready (check with `kubectl get pods`)
make port-forward

# Upgrade jupyterhub as the configs/config-minikube.yaml changed
make upgrade

# Uninstall jupyterhub
make uninstall
```

