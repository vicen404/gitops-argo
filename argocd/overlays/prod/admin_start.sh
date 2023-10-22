#kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

#1234
kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "$2a$10$vnbG74RaxzyCgROlMhOkbek.tbiz//.p8/eSktHww3y4Uo30Q/2j2",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'
kubectl patch configmap argocd-cm -n argocd --patch '{ "data": { "admin.enabled": "true" } }'
patch ingress argo-cd-ui -n argocd --patch '{"apiVersion":"networking.k8s.io/v1","kind":"Ingress","metadata":{"annotations":{"ingress.kubernetes.io/app-root":"/","ingress.kubernetes.io/proxy-body-size":"100M"},"name":"argo-cd-ui","namespace":"argocd"},"spec":{"ingressClassName":"nginx","rules":[{"host":"argocd.3.77.94.204.nip.io","http":{"paths":[{"backend":{"service":{"name":"argocd-server","port":{"name":"http"}}},"path":"/","pathType":"ImplementationSpecific"}]}}],"tls":[{"hosts":["argocd.3.77.94.204.nip.io"],"secretName":"argocd-secret"}]}}'


