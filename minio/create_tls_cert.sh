rm tls* 
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.cert -subj "/CN=minio-tenant.nexus.io/O=minio-tenant.nexus.io"
kubectl create secret tls nginx-console-tls --key tls.key --cert tls.cert -n backuprepo

rm tls* 
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.cert -subj "/CN=minio.nexus.io/O=minio.nexus.io"
kubectl create secret tls nginx-tls --key tls.key --cert tls.cert -n backuprepo
