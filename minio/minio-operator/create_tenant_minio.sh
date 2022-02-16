kubectl minio init
kubectl create ns minio
kubectl minio tenant create minio --servers 3 --volumes 6 --capacity 12Gi --namespace minio --storage-class kadalu.storage-pool-1
