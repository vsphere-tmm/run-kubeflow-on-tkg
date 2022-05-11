#!/bin/bash
FILE_SERVER_ADDR=fs1.vmware.env.com
FILE_SHARE_PATH=/vsanfs/MLData
USER_NAMESPACE=kubeflow-user-example-com
DATA_PVC_SIZE_GB=700

helm repo add nfs-subdir-external-provisioner https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner
helm repo update

rm -f pv*.yaml
cp pv-values.yaml.template pv-values.yaml
sed "s#<FILE_SERVER_ADDR>#${FILE_SERVER_ADDR}#g" -i pv-values.yaml
sed "s#<FILE_SHARE_PATH>#${FILE_SHARE_PATH}#g" -i pv-values.yaml

cp pvc-mlshare.yaml.template pvc-mlshare.yaml
sed "s#<DATA_PVC_SIZE_GB>#${DATA_PVC_SIZE_GB}#g" -i pvc-mlshare.yaml

helm install nfs-subdir-external-provisioner --namespace $ {USER_NAMESPACE} nfs-subdir-external-provisioner/nfs-subdir-external-provisioner -f pv-values.yaml
kubectl apply -f pvc-mlshare.yaml

kubectl get pv,pvc -n kubeflow-user-example-com


