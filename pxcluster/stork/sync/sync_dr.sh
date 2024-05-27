# Creacion del clusterpair
clusterpair.sh

# Comprobacion
storkctl get clusterpair migration-cluster-pair -n kube-system

# Creacion del schedule policy con 2 minutos de sincronizacion de objetos
# Los datos se sincronización en sincrono
kubectl apply -f schedule_policy.yaml

# Creacion del migration schedule
kubectl apply -f migration_schedule.yaml

# Comprobacion
storkctl get migration -n kube-system

# Se introduce algun cambio en la aplicacion

# Se para la apliacion
kubectl delete ns petclinic

# Failover
# Desactivar el clusterdomain local
storkctl deactivate clusterdomain cluster-1 --wait

# Suspender las replicas
storkctl suspend migrationschedule appmigrationschedule -n kube-system

# Comprobacion
storkctl get migrationschedule -n kube-system

# Login en master-2
# Levantamos la apliacion
storkctl activate migration -n petclinic

