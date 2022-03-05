#!/bin/zsh

rm controller* 1>/dev/null 2>&1
rm kubeseal* 1>/dev/null 2>&1

echo "Descargando la controladora de sealed-secret"
version=$(curl -s "https://github.com/bitnami-labs/sealed-secrets"|grep "releases\/tag"|awk '{print $NF}'|awk -F\/ '{print $NF}'|sed "s/\">//g")

wget -q "https://github.com/bitnami-labs/sealed-secrets/releases/download/$version/controller.yaml"

echo "Descargando el cliente kubeseal"
wget -q "https://github.com/bitnami-labs/sealed-secrets/releases/download/$version/kubeseal-$(echo $version|sed "s/v//g")-linux-amd64.tar.gz" && tar -xvf kubeseal-$(echo $version|sed "s/v//g")-linux-amd64.tar.gz kubeseal

sudo mv ./kubeseal /usr/local/bin

rm kubeseal* 1>/dev/null 2>&1

echo "Instalando la controladora de kubeseal"
kubectl apply -f controller.yaml

# La utilidad kubeseal debe estar instalada en el path 
# Se usa simplemente kubeseal a la hora de crear la secret.
# Para ello se pipea a kubeseal. 
# Si por ejemplo la secret esta definida en el 
# archivo secret-minio-operator.yaml se pipea con kubeseal
# y se obtiene la salida en formato que ya se le puede 
# pasar al cluster

# cat secret-minio-operator.yaml|kubeseal |tee secret-minio-operator-sealed.yaml 

# Para crear la secret, simplemente 
# kubectl apply -f secret-minio-operator-sealed.yaml

echo
echo "A partir de ahora se pueden generar secrets encriptadas"
echo "con:"
echo "cat secret-no-cifrada.yaml|kubeseal|tee secret-cifrada.yaml"
echo "kubectl apply -f secret-cifrada.yaml"
echo 
if [ $(ls |grep "backup.clave."|wc -l) -gt 0 ]
then
echo "Se ha detectado backup de clave maestra"
echo -ne "Desea restaurar una copia (s/n)? " && read -k 1 -s resta
echo
if [ "$resta" = "s" ] || [ "$resta" = "S" ]  
then
        ls|grep "backup.clave."|awk '{print NR,$0}'
        echo -ne "Introduzca un valor: " && read -k 1 -s valor
        [ "$valor" -le 0 ] && echo "Valor no valido" && return 1
        [ "$valor" -gt $(ls |grep "backup.clave."|wc -l) ] && echo "Valor no valido" && exit 1
	echo
        clave=$(ls|grep "backup.clave."|head -$valor|tail -1|awk '{print $1}')
	name=$(kubectl get secret -n kube-system|grep sealed-secrets-key|awk '{print $1}')
	kubectl delete secret $name -n kube-system
	kubectl apply -f $clave
	echo "Clave $clave restaurada"
	echo "Reiniciando la controladora"
	kubectl delete pod -n kube-system -l name=sealed-secrets-controller
	exit 0
fi
fi

echo "Se realiza un backup de la clave maestra: backup.clave.$(date +%Y-%m-%d-%H:%m)"
name=$(kubectl get secret -n kube-system|grep sealed-secrets-key|awk '{print $1}')
kubectl get secret $name -n kube-system -o yaml > backup.clave.$(date +%Y-%m-%d-%H:%m)
fi
