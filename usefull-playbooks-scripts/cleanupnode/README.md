Cleaning up docker storage / resetting Docker storage.  
  
As you download container images and run and delete containers, Docker does not always free up mapped disk space. As a result, over time you can run out of space on a node, which might prevent OpenShift Container Platform from being able to create new pods or cause pod creation to take several minutes .

Insure you have the right account for become for localhost work in the playbook  


To this end a playbook was writen to automate this process outlined here.  
https://docs.openshift.com/container-platform/3.11/admin_guide/manage_nodes.html

Requirements:
Ansbible 2.9 (test with) 
Python2/3 (tested with 3)
openshift-ansible.noarch <-- version to match your cluster
python2-jmespath-0.9.0-3.el7.noarch
python2-kubernetes.noarch
python2-openshift.noarch
