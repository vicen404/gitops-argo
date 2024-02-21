[ ! $SERVER ] && echo "Variable SERVER no establecida" && exit 1
envsubst < warp-prod-ingress-wsgi.yaml |kubectl apply -f -
