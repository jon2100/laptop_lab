*Defrag the etcd OCP 3.11  
The playbook will run a backup prior to running a defrag of the etcd the defrag is run in serial with 1 at a time set.  
There are supporting scripts that run and do the heavy lifting due ot not being able to run etcdctl3 or ECTDCTL_API=3 etcdctl from inside a script, playbook or remotely it mush run and have root's env passed to it so you could run ssh host sudo -i command but that will not work for varibles that ned to be set.

There is a /usr/local/bin/master-exec.sh that is setup as a var, when you want to run etcdctl3 you much pass this as a var  
MASTER_EXEC="/usr/local/bin/master-exec.sh"   
Then to use it ${MASTER_EXEC} etc etc -c "ETCDCTL_API=3 etcdctl <pass your certs and keys> <command>  

The supporting bash scripts will run form /tmp/ of the control-plane nodes  





TODO:
Add error checking so that if 1 or more control-plane nodes /etcd-db are down no defrag will happen




---
Refrance documentation:  
https://access.redhat.com/solutions/3259921

