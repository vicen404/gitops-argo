storkctl create clusterpair migration-cluster-pair \
--namespace kube-system \
--dest-kube-file destination-kubeconfig-file \
--src-kube-file source-kubeconfig-file \
--disable-ssl \
--bucket bucket1 \
--provider s3 \
--s3-endpoint minio.192.168.48.10.nip.io \
--s3-access-key minio \
--s3-secret-key minio123 \
--s3-region default \
--dest-ep portworx.192.168.48.20.nip.io \
--src-ep portworx.192.168.48.10.nip.io