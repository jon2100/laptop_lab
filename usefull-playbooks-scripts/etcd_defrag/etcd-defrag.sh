#!/bin/bash -x

# Check for healthy etcd and control plane 

# source /etc/etcd/etcd.conf
export ETCDCTL_API=3

# Setting up to run compact

# Setup vars

MASTER_EXEC="/usr/local/bin/master-exec"
ETCD_POD_MANIFEST="/etc/origin/node/pods/etcd.yaml"
ETCD_EP=$(grep https ${ETCD_POD_MANIFEST} | cut -d "/" -f3 )

ETCD_TRUSTED_CA_FILE=/etc/etcd/ca.crt
ETCD_PEER_CERT_FILE=/etc/etcd/peer.crt
ETCD_PEER_KEY_FILE=/etc/etcd/peer.key
ETCD_LISTEN_CLIENT_URLS=`cat /etc/etcd/etcd.conf | grep -i ETCD_LISTEN_CLIENT_URLS |  sed 's/:*$//g'`
MEMBER_IP=`hostname -i`




etcd_health_ck=`${MASTER_EXEC} etcd etcd -c "ETCDCTL_API=3 etcdctl --cert=/etc/etcd/peer.crt --key=/etc/etcd/peer.key --cacert=/etc/etcd/ca.crt --endpoints ${ETCD_EP} endpoint health 2>&1" |grep -iow healthy | wc -l`
if [[ $etcd_health_ck -lt 3 ]]; then
  echo "etcd healthy"
  ctl_pln=`oc get nodes | grep -i master | awk '{print $2}' | grep -iwo ready | wc -l`
  if [[ $ctl_pln -lt 3 ]]; then
    echo Control plane is not ready
    exit 0
  else
    echo control plane is ready
  fi
else
  echo "etcd unhealty"
   exit 0
fi
echo running scripts 



defrag () {
  
  # Setting up endpoints
  ENDPOINTS=`${MASTER_EXEC} etcd etcd /bin/sh -c "ETCDCTL_API=3 etcdctl --cert=$ETCD_PEER_CERT_FILE --key=$ETCD_PEER_KEY_FILE --cacert=$ETCD_TRUSTED_CA_FILE --endpoints=$ETCD_EP --write-out=fields member list | grep -i ClientURL | cut -d ":" -f2-4 | sed 's/./&,/'| sed -r 's/^.{1}//'"`

  ETCD_ALL_ENDPOINTS=`echo $ENDPOINTS | sed -r 's/^.{1}//g'| sed -r 's/ //g'`
  
  # Grabbing endpint status for etcd cluster 
   ${MASTER_EXEC} etcd etcd /bin/sh -c "ETCDCTL_API=3 etcdctl --cert=$ETCD_PEER_CERT_FILE --key=$ETCD_PEER_KEY_FILE --cacert=$ETCD_TRUSTED_CA_FILE --endpoints=$ETCD_ALL_ENDPOINTS --write-out=table endpoint status" 
  
  # Compacting 
  rev=`${MASTER_EXEC} etcd etcd /bin/sh -c "ETCDCTL_API=3 etcdctl --cert=$ETCD_PEER_CERT_FILE --key=$ETCD_PEER_KEY_FILE --cacert=$ETCD_TRUSTED_CA_FILE --endpoints=$ETCD_EP endpoint status --write-out=\"json\" 2>&1" | egrep -o '\"revision\":[0-9]*' | egrep -o '[0-9]*' -m1`
 
  ${MASTER_EXEC} etcd etcd /bin/sh -c "ETCDCTL_API=3 etcdctl  --cert=$ETCD_PEER_CERT_FILE --key=$ETCD_PEER_KEY_FILE --cacert=$ETCD_TRUSTED_CA_FILE --endpoints=$ETCD_ALL_ENDPOINTS compact $rev"
  
 # defraging 
 ${MASTER_EXEC} etcd etcd /bin/sh -c "ETCDCTL_API=3 etcdctl  --cert=$ETCD_PEER_CERT_FILE --key=$ETCD_PEER_KEY_FILE --cacert=$ETCD_TRUSTED_CA_FILE --command-timeout=30s --endpoints=https://$MEMBER_IP:2379 defrag"
 
 # Print table after for check
 ${MASTER_EXEC} etcd etcd /bin/sh -c "ETCDCTL_API=3 etcdctl --cert=$ETCD_PEER_CERT_FILE --key=$ETCD_PEER_KEY_FILE --cacert=$ETCD_TRUSTED_CA_FILE --endpoints=$ETCD_ALL_ENDPOINTS --write-out=table endpoint status" 
 

 
}

defrag

exit 0
