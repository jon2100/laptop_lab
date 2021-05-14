This playbook set the optins veriable in /etc/sysconfig/docker with the following:  

OPTIONS=' --selinux-enabled --log-driver=json-file --signature-verification=false --log-opt max-size=1M --log-opt mas-file=3'  
  
This is intended to be a post install task but can be run on live clusters during a maintenance window.  
Caution as the pause may need to be adjusted for cluster already being used, though it intent it to not create an outage and will do servers in a serial fastion.  
  
The docker.service is restarted after the entry is made, it will not restart if no changes were made.  
  
Usage:  
ansible-playbook -i <inventory hosts file> ./docker_logging/docker-logging.yml
