export SERVER='192.168.48.10'
[ ! $SERVER ] && echo "Variable SERVER no establecida" && exit 1
envsubst < portworx-nginx.yaml |kubectl apply -f -
