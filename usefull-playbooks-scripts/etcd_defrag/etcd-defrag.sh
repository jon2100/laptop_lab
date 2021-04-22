#!/bin/bash -x
# source /etc/etcd/etcd.conf
export ETCDCTL_API=3

# Setting up to run compact

# Setup vars

MASTER_EXEC="/usr/local/bin/master-exec"
ETCD_POD_MANIFEST="/etc/origin/node/pods/etcd.yaml"
MEMBER_IP=`hostname -i`

ETCD_TRUSTED_CA_FILE=/etc/etcd/ca.crt
ETCD_PEER_CERT_FILE=/etc/etcd/peer.crt
ETCD_PEER_KEY_FILE=/etc/etcd/peer.key
ETCD_LISTEN_CLIENT_URLS=`cat /etc/etcd/etcd.conf | grep -i ETCD_LISTEN_CLIENT_URLS |  sed 's/:*$//g'`
MEMBER_IP=`hostname -i`

defrag () {
  
  # setting up local endpoint
  ETCD_EP=$(grep https ${ETCD_POD_MANIFEST} | cut -d "/" -f3 )
  
  # Setting up endpoints
  ENDPOINTS=`${MASTER_EXEC} etcd etcd /bin/sh -c "ETCDCTL_API=3 etcdctl --cert=$ETCD_PEER_CERT_FILE --key=$ETCD_PEER_KEY_FILE --cacert=$ETCD_TRUSTED_CA_FILE --endpoints=$ETCD_EP --write-out=fields member list | grep -i ClientURL | cut -d ":" -f2-4 | sed 's/./&,/'| sed -r 's/^.{1}//'"`

  ETCD_ALL_ENDPOINTS=`echo $ENDPOINTS | sed -r 's/^.{1}//g'| sed -r 's/ //g'`
  
  # Grabbing endpint status for etcd cluster 
   ${MASTER_EXEC} etcd etcd /bin/sh -c "ETCDCTL_API=3 etcdctl --cert=$ETCD_PEER_CERT_FILE --key=$ETCD_PEER_KEY_FILE --cacert=$ETCD_TRUSTED_CA_FILE --endpoints=$ETCD_ALL_ENDPOINTS --write-out=table endpoint status" 
  
  # Compacting 
  ${MASTER_EXEC} etcd etcd /bin/sh -c "ETCDCTL_API=3 etcdctl --cert=$ETCD_PEER_CERT_FILE --key=$ETCD_PEER_KEY_FILE --cacert=$ETCD_TRUSTED_CA_FILE --endpoints=$ETCD_EP endpoint status --write-out=\"json\"  " > testme.txt
  rev=`cat testme.txt | egrep -o '"revision":[0-9]*' | egrep -o '[0-9]*' -m1`
  
  ${MASTER_EXEC} etcd etcd /bin/sh -c "ETCDCTL_API=3 etcdctl  --cert=$ETCD_PEER_CERT_FILE --key=$ETCD_PEER_KEY_FILE --cacert=$ETCD_TRUSTED_CA_FILE --endpoints=$ETCD_ALL_ENDPOINTS compact $rev"
  
 # defraging 
 ${MASTER_EXEC} etcd etcd /bin/sh -c "ETCDCTL_API=3 etcdctl  --cert=$ETCD_PEER_CERT_FILE --key=$ETCD_PEER_KEY_FILE --cacert=$ETCD_TRUSTED_CA_FILE --command-timeout=30s --endpoints=https://$MEMBER_IP:2379 defrag"

 
}

defrag

# cleanup 
rm testme.txt
exit 0
