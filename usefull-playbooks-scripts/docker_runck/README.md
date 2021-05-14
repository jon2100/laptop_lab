This playbook will check already provisioned cluster nodes and insure that the docker service and atomic-openshift-node.service are running and enabled.   

Caution: Do not run on clusters that are in maintenance it may try to start docker service when you do not want it to run.  
 
Usage:  
ansible-playbook -i <inventory file> ./docker_runchk/docker_runck.yml  

