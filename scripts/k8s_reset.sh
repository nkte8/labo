#!/bin/bash
nodelist="master01
master02
master03
node01
node02
node03
node04"

for n in $nodelist;do 
    ssh -t -o StrictHostKeyChecking=no -o ServerAliveInterval=30 $n sh -c "yes | sudo kubeadm reset;
    sudo rm -rf /var/lib/kubelet /var/lib/dockershim /var/lib/etcd /var/lib/cni /etc/kubernetes /etc/cni;
    sudo iptables -FX;
    sudo reboot"
done