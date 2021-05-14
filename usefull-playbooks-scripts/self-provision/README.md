Removes self provisioning capabilities from cluster

Usage:  
ansible-playbook -i <inventory file> self-provision/remove-self-provision.yaml

This will copy a script (rmshlfpro.sh) to the first master and run   

Refrance:  
https://docs.openshift.com/container-platform/3.11/admin_guide/managing_projects.html#disabling-self-provisioning
