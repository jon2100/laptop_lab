Custom Playbooks an yamls
---
Requirements:  

For Python2:  
 - python2-jmespath-0.9.0-6.el7_7.noarch  
 - python2-openshift.noarch  
 - python-passlib-1.6.5-1.1.el7.noarch

For Python3
 - libselinux-python3.x86_64
 - and above modules

---
Playbooks:  For OpenShift 3.11 clustes.  
  
auto-htpasswd - (This playbook is used to change passowrd of a user in the htpasswd on the control-plane)
  
custom_grafana - (This sets up a custom grafana instance with custom dashboards)  
  
etcd_defrag - (Automation to backup and defrag etcd)  
  
etcdmonitoring - (Sets up etcd monitoring in Prometheus)  
  
cleanupnode - (Cleans up orphan data from cluster nodes, by resetting docker storage * does not do Control-plane)  
  
self-proision - (Removes self provisioning from cluster)

preflight - (checks nodes for commonly missed settings)

docker_logging - (Sets options for log retention for the docker deamon)

docker_runck - (Starts and enables docker.service and atomic-openshift-node.service if it is not set already) 

pv_term - (removes pvs stuck in terminatin by setting finilizers to null)

rm_twistlock - (Removes twistlock - SSC, clusterrolebindings, clusterrole, namespace)

cluster-backup - (Backsup etcd, /etc/orgin , certs, projects, retains 3 days (changeable)


