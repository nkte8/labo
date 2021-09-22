#!/bin/bash
# which cfssl
# if [[ $? -ne 0 ]] ;then
#     sudo apt install -y golang-cfssl
# fi
cfssl gencert -initca ca-csr.json | cfssljson -bare ca

mv ca.pem ca.crt
mv ca-key.pem ca.key