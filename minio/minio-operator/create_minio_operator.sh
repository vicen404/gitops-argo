kubectl minio init
echo "Esperando 20s"
sleep 20
kubectl apply -f ingress-console-operator.yaml -n minio-operator
