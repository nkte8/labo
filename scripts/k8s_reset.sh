#!/bin/bash

nodelist=$*
if [[ $nodelist == "" ]];then
    nodelist=`kubectl get node -o name | cut -d "/" -f 2 | sort -r | tr '\n' ' '`
fi

for n in $nodelist;do 
    kubectl delete node $n
    ssh -t -o StrictHostKeyChecking=no -o ServerAliveInterval=30 $n sh -c "yes | sudo kubeadm reset;
    sudo rm -rf /var/lib/kubelet /var/lib/dockershim /var/lib/etcd /var/lib/cni /etc/kubernetes /etc/cni;
    sudo iptables -FX;
    sudo reboot"
done