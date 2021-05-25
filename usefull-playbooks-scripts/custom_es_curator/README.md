This playbook is to set the curator to delete indices of non OCP projecs on a 3 day interval and other on 5 day.  
All retention times are adustable by modifiying the date fields in the new-curator.yml.  
Included is a default logging-curator ConfigMap incase one needs to revert to a default state. (default-curator.yml).  
Change src in the playbook and run.  

Refrance Documentation:  
https://docs.openshift.com/container-platform/3.11/install_config/aggregate_logging.html#configuring-curator  


---
Usage:
ansible-playbooks -i <inventory_file> <path to playbook>/custom_es_curator/custom-log-curator.yml
