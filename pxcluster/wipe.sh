# Delete storagecluster 
kubectl delete storagecluster px-cluster-ef564cdd-2afb-4a08-b23f-f11331bd0cab -n kube-system
# Every node to wipe
sudo systemctl stop portworx
/opt/pwx/bin/pxctl sv nw --all
sudo wipefs -a -f /dev/sdb
sudo systemctl start portworx

# for node in node1 node2 node3 node4; do ssh $node 'sudo systemctl stop portworx && sudo /opt/pwx/bin/pxctl sv nw --all && sudo wipefs -a -f /dev/sdb && sudo systemctl start portworx';done
