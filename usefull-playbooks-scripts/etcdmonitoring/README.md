Setting up ETCD Monitoring.  
1. Directory layout  
  a. etcdmonit.yaml place in your vars directory tipically inventory/group_vars/{subdir}/  
  b. template directory for this playbook provided, if changed it will need to be changed in the playbook 
  c. etcdmon-setup.yaml place where you run playbooks from tipically playbook_dir  
2. Insure correct directory call out in files, the etcdworking is a directory that gets created to do all the work in and keep your playbook_dir clean
3. run playbook etcdmon-setup.yaml  
4. Add the following to your inventory/hosts file to insure persistance through upgrades  
  a. openshift_cluster_monitoring_operator_etcd_enabled=true

---  
Refrance documentation:  
* https://docs.openshift.com/container-platform/3.11/install_config/prometheus_cluster_monitoring.html#configuring-etcd-monitoring_prometheus-cluster-monitoring  

