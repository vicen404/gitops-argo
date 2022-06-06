# Edit StorageCluster and add to spec
apiVersion: core.libopenstorage.org/v1
kind: StorageCluster
metadata:
  name: portworx
  namespace: kube-system
spec:
  deleteStrategy:
    type: UninstallAndWipe


kubectl delete StorageCluster <your-storagecluster> -n <name-space> kube-system
