This playbook is for updating the password for a user in htpasswd for Openshift 3.11  
---
Requirements:  
python-passlib-1.6.5-1.1.el7.noarch  
python2-openshift.noarch  

This playbook will do the following:  
  
1. Clean up any backup htpasswd files from previous runs  
2. Copy htpasswd local  
3. Create new htpasswd  
4. Copy htpasswd to all Control Plane nodes  
5. Clean up loacal working directory  

Usage:  
ansible-playbook -i <inventory_file> auto-htpasswd/autohtpasswd.yaml
