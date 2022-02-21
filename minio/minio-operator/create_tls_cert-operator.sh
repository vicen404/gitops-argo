#rm tls* 
#kubectl create ns minio

#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls-console.key -out tls-console.crt -subj "/CN=minio-operator.10.1.1.120.traefik.me/O=minio-operator.10.1.1.120.traefik.me"
kubectl create secret tls nginx-operator-tls --key traefikme.key --cert traefikme.crt -n minio-operator

#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls-storage.key -out tls-storage.crt -subj "/CN=minio-storage.10.1.1.120.traefik.me/O=minio-storage.10.1.1.120.traefik.me"
kubectl create secret tls nginx-storage --key traefikme.key --cert traefikme.crt -n minio-storage

#openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls-storage-console.key -out tls-storage-console.crt -subj "/CN=minio-storage-console.10.1.1.120.traefik.me/O=minio-storage-console.10.1.1.120.traefik.me"
kubectl create secret tls nginx-storage-console --key traefikme.key --cert traefikme.crt -n minio-storage
