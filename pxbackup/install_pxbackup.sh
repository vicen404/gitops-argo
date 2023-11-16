#!/bin/bash

echo "Instalando helm"
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash 1>/dev/null 2>&1

helm repo add portworx http://charts.portworx.io/ && helm repo update
helm install px-central portworx/px-central --namespace central --create-namespace --version 2.5.1 -f $HOME/values-px-central.yaml
