# Creacion del clusterpair
clusterpair.sh

# Comprobacion
storkctl get clusterpair migration-cluster-pair -n kube-system

# Creacion del schedule
kubectl apply -f schedule.yaml

# Creacion del migration schedule
kubectl apply -f migration_schedule.yaml

