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
- apiGroups: ["stork.libopenstorage.org"] # for controller support
  resources: ["*"]
  verbs: ["create", "delete", "deletecollection", "get", "list", "patch", "update", "watch"]
- apiGroups: ["snapshot.storage.k8s.io"] # px-backup need list volumesnapshotclasses
  resources: ["volumesnapshotclasses"]
  verbs: ["get", "list", "watch"]

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

EOF
}

modkconfig () {

user_clinic_crt=$(cat dev_appclinic.crt | base64 | tr -d '\n')
user_clinic_key=$(cat dev_appclinic.key | base64 | tr -d '\n')
user_sock_crt=$(cat dev_appsock.crt | base64 | tr -d '\n')
user_sock_key=$(cat dev_appsock.key | base64 | tr -d '\n')

echo
echo "Modify the kubeconfig file with"
echo "this changes:"
echo
echo "Add to context in kubeconfig:
- context:
    cluster: kubernetes
    namespace: petclinic
    user: dev_appclinic
  name: dev_appclinic-context
- context:
    cluster: kubernetes
    namespace: sock-shop
    user: dev_appsock
  name: dev_appsock-context
"
echo
echo "Add to users in kubeconfig:
- name: dev_appclinic
  user:
    client-certificate-data: $user_clinic_crt
    client-key-data: $user_clinic_key
- name: dev_appsock
  user:
    client-certificate-data: $user_sock_crt
    client-key-data: $user_sock_key
"
}

cert
roles
modkconfig

echo "You can change your context:
kubectl config use-context dev_appclinic-context
kubectl config use-context dev_appsock-context"
