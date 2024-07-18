cert () {
openssl genrsa -out dev_appclinic.key 2048
openssl req -new -key dev_appclinic.key -out dev_appclinic.csr -subj "/CN=dev_appclinic"
openssl genrsa -out dev_appsock.key 2048
openssl req -new -key dev_appsock.key -out dev_appsock.csr -subj "/CN=dev_appsock"
a=$(cat dev_appclinic.csr | base64 | tr -d '\n')
b=$(cat dev_appsock.csr | base64 | tr -d '\n')
cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: dev-appclinic-csr
spec:
  request: $a
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
---
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: dev-appsock-csr
spec:
  request: $b
  signerName: kubernetes.io/kube-apiserver-client
  usages:
  - client auth
EOF
echo "Approving cert"
kubectl certificate approve dev-appclinic-csr
kubectl certificate approve dev-appsock-csr

echo "Downloading cert"
kubectl get csr dev-appclinic-csr -o jsonpath='{.status.certificate}' | base64 --decode > dev_appclinic.crt
kubectl get csr dev-appsock-csr -o jsonpath='{.status.certificate}' | base64 --decode > dev_appsock.crt
}

roles () {
kubectl create ns petclinic
kubectl create ns sock-shop
kubectl apply -f perm.yaml
exit
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: view-all-cluster-resources
rules:
- apiGroups: [""]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apps", "extensions"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["batch"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["autoscaling"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["policy", "rbac.authorization.k8s.io"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["networking.k8s.io"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["storage.k8s.io"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["apiextensions.k8s.io"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["scheduling.k8s.io"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["coordination.k8s.io"]
  resources: ["*"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["stork.libopenstorage.org"]
  resources: ["schedulepolicies"]
  verbs: ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]
- apiGroups: ["stork.libopenstorage.org"] # for controller support
  resources: ["*"]
  verbs: ["list", "get", "watch"]
- apiGroups: ["snapshot.storage.k8s.io"]
  resources: ["volumesnapshotclasses"]
  verbs: ["get", "list"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: view-all-cluster-resources-binding
subjects:
- kind: User
  name: dev_appclinic
  apiGroup: rbac.authorization.k8s.io
- kind: User
  name: dev_appsock
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: view-all-cluster-resources
  apiGroup: rbac.authorization.k8s.io

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: petclinic
  name: admin-role-petclinic
rules:
- apiGroups: [""]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["apps", "extensions"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["batch"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["autoscaling"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["rbac.authorization.k8s.io"]
  resources: ["*"]
  verbs: ["*"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: admin-rolebinding-petclinic
  namespace: petclinic
subjects:
- kind: User
  name: dev_appclinic
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: admin-role-petclinic
  apiGroup: rbac.authorization.k8s.io

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: sock-shop
  name: admin-role-sock-shop
rules:
- apiGroups: [""]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["apps", "extensions"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["batch"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["autoscaling"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["rbac.authorization.k8s.io"]
  resources: ["*"]
  verbs: ["*"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: admin-rolebinding-sock-shop
  namespace: sock-shop
subjects:
- kind: User
  name: dev_appsock
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: admin-role-sock-shop
  apiGroup: rbac.authorization.k8s.io

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: central
  name: admin-role-central
rules:
- apiGroups: [""]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["apps", "extensions"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["batch"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["autoscaling"]
  resources: ["*"]
  verbs: ["*"]
- apiGroups: ["rbac.authorization.k8s.io"]
  resources: ["*"]
  verbs: ["*"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: admin-rolebinding-central-dev_appclinic
  namespace: central
subjects:
- kind: User
  name: dev_appclinic
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: admin-role-central
  apiGroup: rbac.authorization.k8s.io

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: admin-rolebinding-central-dev_appsock
  namespace: central
subjects:
- kind: User
  name: dev_appsock
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: admin-role-central
  apiGroup: rbac.authorization.k8s.io

EOF
}

cert
roles
