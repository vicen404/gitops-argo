#rm tls* 
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls-console.key -out tls-console.crt -subj "/CN=minio-operator.cluster.local/O=minio-operator.cluster.local"
#kubectl create ns minio
kubectl create secret tls nginx-operator-tls --key tls-console.key --cert tls-console.crt -n minio-operator

#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls-storage.key -out tls-storage.crt -subj "/CN=minio-storage-console.cluster.local/O=minio-storage-console.cluster.local"
kubectl create secret tls nginx-storage --key tls-storage.key --cert tls-storage.crt -n minio-storage
