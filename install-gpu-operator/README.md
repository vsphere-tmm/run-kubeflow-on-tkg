fill the following values in install-gpu-operator.sh, and then run the script to install gpu operator

helm is needed as pre-requisite

by default, the private_registry name should be nvcr.io/nvaie

PRIVATE_REGISTRY=

NGC_API_KEY=

NGC_EMAIL_ID=

below are default values, don't change unless you have different repo and chart name

HELM_REPO=nvaie

CHART_NAME=gpu-operator
