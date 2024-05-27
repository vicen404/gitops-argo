storkctl create clusterpair migration-cluster-pair \
--namespace kube-system \
--src-kube-file source-kubeconfig-file \
--dest-kube-file destination-kubeconfig-file \
--mode sync-dr
