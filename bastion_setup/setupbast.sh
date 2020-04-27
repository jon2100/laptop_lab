# script to setup bastion to get ready
sudo subscription-manager register --username={Portal UserName} --password='{Portal Passowrd}'
sleep 5
sudo subscription-manager attach --pool={Entitlement pool}
sleep 5
sudo subscription-manager repos --disable="*"
sleep 5
sudo rm -f /etc/yum.repos.d/*
sudo yum repolist
clear


sudo subscription-manager repos --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms" --enable="rhel-7-server-ose-3.11-rpms" --enable="rhel-7-server-ansible-2.6-rpms"

## Recomened if you want to lock in a version
# https://access.redhat.com/solutions/98873
sudo yum install -y yum-plugin-versionlock
sudo cp versionlock.list /etc/yum/pluginconf.d/versionlock.list

sudo yum -y install wget git net-tools bind-utils yum-utils bridge-utils bash-completion kexec-tools sos psacct vim screen

sudo yum install -y atomic openshift-ansible (versions) 
# example:
# sudo yum install openshift-ansible-roles-3.11.153 openshift-ansible-playbooks-3.11.153 openshift-ansible-3.11.153 openshift-ansible-docs-3.11.153 atomic-openshift-clients-3.11.153 atomic-1.22

# reboot
sudo yum -y update
