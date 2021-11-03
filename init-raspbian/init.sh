#!/bin/bash

cd $(dirname $0)
read -p "skip[y/n]: " skip 
if [[ ${skip} != "y" ]];then 
    [[ ${W_SSID:=} == "" ]] && read -p "W_SSID: " W_SSID
    [[ ${W_PASS:=} == "" ]] && read -p "W_PASS: " W_PASS
    echo "> wpa_passphrase ${W_SSID} ${W_PASS}"
    cat <<EOF > ./wpa_supplicant.conf
country=JP
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
EOF
    docker run --rm -it ubuntu:20.04 sh -c "apt-get update >/dev/null 2>&1 && apt-get install -y wpasupplicant >/dev/null 2>&1 && wpa_passphrase ${W_SSID} ${W_PASS}" >> ./wpa_supplicant.conf
    [[ $? -ne 0 ]] && exit 1
    sed -i '' '/#psk/d' ./wpa_supplicant.conf
    sed -i '' 's/'$'\r''$//' ./wpa_supplicant.conf
    echo "ok"
fi

read -p "Input /boot volume: " B_VOL
[[ ! -e "${B_VOL%%/}/" ]] && echo "Invalid path: ${B_VOL}" && exit 1
touch ./ssh
cp -v ./ssh ./wpa_supplicant.conf ${B_VOL%%/}/
ls -lrt ${B_VOL} | tail -2

echo "finished!"
read -p "pls boot RPi... [ready -> Enter]" 
read -p "IP address... W_IP: " W_IP 
echo "login with init password 'raspberry'"

USERNAME=`whoami`
PUBKEY=$(cat `find ~/.ssh -name '*.pub' | head -n 1`)
ssh -t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null pi@raspberrypi.local \
"sudo apt-get update --allow-releaseinfo-change
sudo apt-get upgrade -y
echo 'interface wlan0' >> /etc/dhcpcd.conf
echo 'static ip_address='${W_IP} >> /etc/dhcpcd.conf
echo 'static routers=192.168.3.1' >> /etc/dhcpcd.conf
echo 'static domain_name_servers=192.168.3.250 8.8.8.8' >> /etc/dhcpcd.conf
sudo useradd -m -U -u 1001 -s /bin/bash -G sudo,video ${USERNAME}
sudo sh -c 'echo ${USERNAME}:${USERNAME} | chpasswd'
sudo mkdir  /home/${USERNAME}/.ssh
echo ${PUBKEY} | sudo tee /home/${USERNAME}/.ssh/authorized_keys
echo '${USERNAME} ALL=(ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/099_${USERNAME}-nopasswd
sudo chmod 440 /etc/sudoers.d/099_${USERNAME}-nopasswd
sudo sed -i -e 's/$/ cgroup_enable=memory cgroup_memory=1 net.ifnames=0 dwc_otg.lpm_enable=0/' /boot/cmdline.txt
sudo passwd -d pi
sudo systemctl disable avahi-daemon 
sudo reboot"

echo "you can access 'ssh ${USERNAME}@${W_IP}' with public-key ${W_PUB_PATH}"