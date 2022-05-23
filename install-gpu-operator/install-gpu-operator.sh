#!/bin/bash

REGISTRY_SECRET_NAME=ngc-secret
PRIVATE_REGISTRY=
NGC_API_KEY=
NGC_EMAIL_ID=

HELM_REPO=nvaie
CHART_NAME=gpu-operator

echo "creating namespace gpu-operator…"
kubectl create ns gpu-operator

echo "creating licensing-config configmap…"
touch gridd.conf
kubectl create configmap licensing-config -n gpu-operator --from-file=gridd.conf --from-file=client_configuration_token.tok

echo "creating ngc-secret…"
kubectl create secret docker-registry ${REGISTRY_SECRET_NAME} \
    --docker-server=${PRIVATE_REGISTRY} --docker-username='$oauthtoken' \
    --docker-password=${NGC_API_KEY} \
    --docker-email=${NGC_EMAIL_ID} -n gpu-operator

helm repo add nvaie https://helm.ngc.nvidia.com/${HELM_REPO} \
  --username='$oauthtoken' --password=${NGC_API_KEY} \
  && helm repo update

echo "verify chart $CHART_NAME in $HELM_REPO"
	helm search repo nvaie -o yaml | grep name: | grep nvaie/${CHART_NAME} && echo SUCCESS || (echo FAIL && exit 1)

echo "installing operator…"
	helm install --wait gpu-operator nvaie/${CHART_NAME} -n gpu-operator


echo "waiting for operator being installed..."

while true
do
kubectl get pods -n gpu-operator | grep nvidia-operator-validator > /dev/null
if [ $? == 0 ]
then
	kubectl get pods -n gpu-operator | grep nvidia-operator-validator | grep -v Running > /dev/null
	if [ $? != 0 ]
	then
  		echo "GPU Operator installed"
  		break
	fi
fi
sleep 10
done
