#rm tls* 
#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls-console.key -out tls-console.crt -subj "/CN=minio-console.cluster.local/O=minio-console.cluster.local"
kubectl create ns minio
kubectl create secret tls nginx-console-tls --key tls-console.key --cert tls-console.crt -n minio

#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls-minio.key -out tls-minio.crt -subj "/CN=minio.cluster.local/O=minio.cluster.local"
kubectl create secret tls nginx-tls --key tls-minio.key --cert tls-minio.crt -n minio
