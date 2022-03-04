#!/bin/bash

espera_pods () {
echo
echo "Esperando a que todos los pods del ns $1 esten preparados..."
sleep 5
if [ $1 = "all" ]
then
while [ "$(kubectl get pods  --all-namespaces --field-selector=status.phase!=Completed,status.phase!=Succeeded -o json  | jq -r '.items[] | select(.status.phase != "Running" or ([ .status.conditions[] | select(.type == "Ready" and .status == "False") ] | length ) == 1 ) | .metadata.namespace + "/" + .metadata.name')" ]; do sleep 15; done
else
while [ "$(kubectl get pods  --namespace $1 --field-selector=status.phase!=Completed,status.phase!=Succeeded -o json  | jq -r '.items[] | select(.status.phase != "Running" or ([ .status.conditions[] | select(.type == "Ready" and .status == "False") ] | length ) == 1 ) | .metadata.namespace + "/" + .metadata.name')" ]; do sleep 15; done
fi
}


# Instalacion cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.7.1/cert-manager.yaml

espera_pods cert-manager

# Instalacion operador harbor
kubectl apply -f https://raw.githubusercontent.com/goharbor/harbor-operator/master/manifests/cluster/deployment.yaml

espera_pods harbor-operator-ns

sleep 20

# Instalando cluster harbor
kubectl apply -f full_stack_cluster_harbor.yaml

espera_pods harbor-ns
