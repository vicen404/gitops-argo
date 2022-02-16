kubectl minio init
kubectl create ns minio
kubectl minio tenant create minio --servers 1 --volumes 4 --capacity 10Gi --namespace minio --storage-class kadalu.storage-pool-1
