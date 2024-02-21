# En primer lugar suspendemos la replica
storkctl suspend migrationschedule migrationschedule-1 -n kube-system

# En segundo lugar bajamos el numero de pods a cero del deploy
kubectl scale --replicas=0 deploy deployment -n warp-prod

# En tercer lugar nos conectamos al cluster de destino y activamos la replica
storkctl activate migration -n kube-system
