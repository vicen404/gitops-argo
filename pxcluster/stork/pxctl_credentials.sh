pxctl cred create \
--provider s3 \
--s3-disable-ssl \
--bucket bucket1 \
--s3-endpoint minio.192.168.48.10.nip.io \
--s3-access-key minio \
--s3-secret-key minio123 \
--s3-region default \
--s3-storage-class \
STANDARD \
minio-repo
