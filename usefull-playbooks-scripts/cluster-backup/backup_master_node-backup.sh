#!/bin/bash
set -eo pipefail
ORIGINFILES="origin-master origin-master-api origin-master-controllers origin-node"
OCPFILES="atomic-openshift-master atomic-openshift-master-api atomic-openshift-master-controllers atomic-openshift-node"

die(){
  echo "$1"
  exit $2
}

usage(){
  echo "$0 [path]"
  echo "  path  The directory where the backup will be stored"
  echo "        /backup/\$(hostname)/\$(date +%Y%m%d) by default"
  echo "Examples:"
  echo "    $0 /my/mountpoint/\$(hostname)"
}

ocpfiles(){
  mkdir -p ${BACKUPLOCATION}/etc/sysconfig
  echo "Exporting OCP related files to ${BACKUPLOCATION}"
  cp -aR /etc/origin ${BACKUPLOCATION}/etc
  for file in ${ORIGINFILES} ${OCPFILES}
  do
    if [ -f /etc/sysconfig/${file} ]
    then
      cp -aR /etc/sysconfig/${file} ${BACKUPLOCATION}/etc/sysconfig/
    fi
  done
}

otherfiles(){
  mkdir -p ${BACKUPLOCATION}/etc/sysconfig
  mkdir -p ${BACKUPLOCATION}/etc/pki/ca-trust/source
  echo "Exporting other important files to ${BACKUPLOCATION}"
  if [ -f /etc/sysconfig/flanneld ]
  then
    cp -a /etc/sysconfig/flanneld \
      ${BACKUPLOCATION}/etc/sysconfig/
  fi
  if [ -d /etc/sysconfig/iptalbes ]
  then
  cp -aR /etc/sysconfig/{iptables,docker-*} \
    ${BACKUPLOCATION}/etc/sysconfig/
  else
  cp -aR /etc/sysconfig/docker-* \
    ${BACKUPLOCATION}/etc/sysconfig/
  fi
  if [ -d /etc/cni ]
  then
    cp -aR /etc/cni ${BACKUPLOCATION}/etc/
  fi
  cp -aR /etc/dnsmasq* ${BACKUPLOCATION}/etc/
  cp -aR /etc/pki/ca-trust/source/anchors \
    ${BACKUPLOCATION}/etc/pki/ca-trust/source/
}

packagelist(){
  echo "Creating a list of rpms installed in ${BACKUPLOCATION}"
  rpm -qa | sort > ${BACKUPLOCATION}/packages.txt
}

if [[ ( $@ == "--help") ||  $@ == "-h" ]]
then
  usage
  exit 0
fi

BACKUPLOCATION=${1:-"/tmp/$(hostname)-$(date +%Y%m%d)"}

mkdir -p ${BACKUPLOCATION}

ocpfiles
otherfiles
packagelist

# Tar/zip 
tar zcfv /tmp/all-files.$(hostname).$(date +%Y%m%d).tar.gz ${BACKUPLOCATION}
rm -rf /tmp/$(hostname)-$(date +%Y%m%d)
exit 0

