#!/bin/sh
cfssl gencert -ca=ca.crt -ca-key=ca.key --config=ca-config.json -profile=kubernetes server-csr.json | cfssljson -bare apiserver

mv apiserver.pem apiserver.crt
mv apiserver-key.pem apiserver.key
