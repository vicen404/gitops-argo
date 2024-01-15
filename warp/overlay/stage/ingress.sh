[ ! $SERVER ] && echo "Variable SERVER no establecida" && exit 1
envsubst < warp-stage-ingress-wsgi.yaml |kubectl apply -f -
