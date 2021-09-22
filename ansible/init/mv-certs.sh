#!/bin/bash
set -x
echo ${PKIPATH:="../roles/kubernetes/build/files/pki"}
mkdir ${PKIPATH} 2>/dev/null
mv apiserver.crt ${PKIPATH}/
mv apiserver.key ${PKIPATH}/
mv ca.crt ${PKIPATH}/
mv ca.key ${PKIPATH}/
set +x

exit 0