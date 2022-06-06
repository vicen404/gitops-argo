kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

#1234
kubectl -n argocd patch secret argocd-secret \                                                                                                                   ─╯
  -p '{"stringData": {
    "admin.password": "$2a$10$vnbG74RaxzyCgROlMhOkbek.tbiz//.p8/eSktHww3y4Uo30Q/2j2",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'
