SHELL := /bin/bash -O globstar
.PHONY: setup init singleuser hub install port-forward upgrade uninstall clean

RELEASE := mini-jupyterhub
NAMESPACE := jupyterhub
HELM_VERSION := 0.9.0
DOCKER_VERSION := fastapi

## Setup minikube
setup:
	bash kube-setup.sh
	kubectl create namespace ${NAMESPACE}

## Initialize minikube
init:
	minikube start --memory 8192 --vm-driver=kvm2
	kubectx minikube
	kubens ${NAMESPACE}

## Create a docker image for singleuser
singleuser:
	cd singleuser && docker build -t singleuser:$(DOCKER_VERSION) .

## Create a docker image for hub.
hub :
	cd hub && docker build -t hub:$(DOCKER_VERSION) .

## Install jupyterhub
install: hub singleuser
	helm upgrade --install ${RELEASE} jupyterhub/jupyterhub \
      --namespace ${NAMESPACE} --version=${HELM_VERSION} \
      --values config.yaml

## Port forwarding (available at localhost:8000)
port-forward:
	kubectl port-forward svc/proxy-public 8000:80

## Upgrade jupyterhub
upgrade:
	helm upgrade ${RELEASE} jupyterhub/jupyterhub --namespace ${NAMESPACE} \
      --version=${HELM_VERSION} --values config.yaml

## Uninstall jupyterhub
uninstall:
	helm uninstall ${RELEASE}

## Cleanup minikube
clean:
	minikube delete


#################################################################################
# Self Documenting Commands                                                     #
#################################################################################

.DEFAULT_GOAL := help

# Inspired by <http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html>
# sed script explained:
# /^##/:
# 	* save line in hold space
# 	* purge line
# 	* Loop:
# 		* append newline + line to hold space
# 		* go to next line
# 		* if line starts with doc comment, strip comment character off and loop
# 	* remove target prerequisites
# 	* append hold space (+ newline) to line
# 	* replace newline plus comments by `---`
# 	* print line
# Separate expressions are necessary because labels cannot be delimited by
# semicolon; see <http://stackoverflow.com/a/11799865/1968>
.PHONY: help
help:
	@echo "$$(tput bold)Available rules:$$(tput sgr0)"
	@echo
	@sed -n -e "/^## / { \
		h; \
		s/.*//; \
		:doc" \
		-e "H; \
		n; \
		s/^## //; \
		t doc" \
		-e "s/:.*//; \
		G; \
		s/\\n## /---/; \
		s/\\n/ /g; \
		p; \
	}" ${MAKEFILE_LIST} \
	| LC_ALL='C' sort --ignore-case \
	| awk -F '---' \
		-v ncol=$$(tput cols) \
		-v indent=19 \
		-v col_on="$$(tput setaf 6)" \
		-v col_off="$$(tput sgr0)" \
	'{ \
		printf "%s%*s%s ", col_on, -indent, $$1, col_off; \
		n = split($$2, words, " "); \
		line_length = ncol - indent; \
		for (i = 1; i <= n; i++) { \
			line_length -= length(words[i]) + 1; \
			if (line_length <= 0) { \
				line_length = ncol - indent - length(words[i]) - 1; \
				printf "\n%*s ", -indent, " "; \
			} \
			printf "%s ", words[i]; \
		} \
		printf "\n"; \
	}' \
	| more $(shell test $(shell uname) = Darwin && echo '--no-init --raw-control-chars')
