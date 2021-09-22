#!/bin/bash

cd $(dirname $0)
read -p "skip[y/n]: " skip 
if [[ ${skip} != "y" ]];then 
    [[ ${W_IP:=} == "" ]] && read -p "W_IP: " W_IP
    UNAME=`whoami`
    PUBKEY=$(cat `find .ssh -name '*.pub' | head -n 1`)

    sed "s/__IP_ADDRESS/${W_IP}/g" ./network-config.base > ./network-config
    sed "s/__USERNAME/${UNAME}/g" ./user-data.base > ./user-data
    sed "s/__AUTHKEY${PUBKEY}/g" ./user-data.base > ./user-data
fi

read -p "Input /boot volume: " B_VOL
[[ ! -e "${B_VOL%%/}/" ]] && echo "Invalid path: ${B_VOL}" && exit 1
cp -v ./user-data ./network-config ${B_VOL%%/}/
ls -lrt ${B_VOL} | tail -2

echo "finished!"
echo "you can access 'ssh ${UNAME}@${W_IP}' with public-key defined by user-data"