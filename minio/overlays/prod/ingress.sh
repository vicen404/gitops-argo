export SERVER=$(curl --silent http://169.254.169.254/latest/meta-data/public-ipv4)
[ ! $SERVER ] && echo "Variable SERVER no establecida" && exit 1
envsubst < ingress-console-yaml |kubectl apply -f -
