# En primer lugar suspendemos la replica en el cluster de origen
storkctl suspend migrationschedule migrationschedule-1 -n petclinic

# En segundo lugar bajamos el numero de pods a cero del deploy en el cluster de origen
kubectl scale --replicas=0 deploy petclinic -n petclinic
kubectl scale --replicas=0 deploy petclinic-db-mysql -n petclinic

# En tercer lugar nos conectamos al cluster de destino y activamos la replica
ssh master-2
storkctl activate migration -n petclinic
