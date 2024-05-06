storkctl create clusterpair migration-cluster-pair \
--namespace petclinic \
--dest-kube-file destination-kubeconfig-file \
--src-kube-file source-kubeconfig-file \
--provider s3 \
--s3-endpoint s3.amazonaws.com \
--s3-access-key AK \
--s3-secret-key SK \
--s3-region eu-central-1 \
--bucket px-backup-avicente
