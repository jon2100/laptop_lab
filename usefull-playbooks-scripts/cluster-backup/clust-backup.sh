#!/bin/bash
echo "Backing up projects"
~/cfg/backup-restore/ocp-project-backup.sh

echo "Backing up ETCD, configs, certs, etc..."
ansible-playbook -i ~/cfg/inventory/hosts ~/cfg/50-backup.yml -e host_dest_dir='~/cfg/backups'

echo "Done"
