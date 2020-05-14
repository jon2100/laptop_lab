Create Bastion server.
* This assumes is a DNS server setup, and new hosts will have access to the internet  
1. create a VM 
   - 1 GB RAM
   - 10 GB Disk
   - 1 vCPU
   - set on desired network
   - 1 cdrom - mount RHEL 7 iso
2. Install OS accept all defaults except the following.
   - set TZ 
   - set Network information 
      - IP 
      - FQDN
   - set root Password
   - set user, passowrd and set as admin
3. After Install login as the admin user * admindude, and set for password less sudo
   - sudo visudo 
     - Comment: %wheel        ALL=(ALL)       ALL
     - Uncomment: %wheel  ALL=(ALL)       NOPASSWD: ALL
4. Generate SSH Key, the pub key will be copied to all hosts in the cluster, and user will need to have sudo access with out password.
   - ssh-keygen -t rsa
     * do not set a password
     accept defaults
5. Copy setupbast.sh to server
Before running the setupbast.sh script you will need to edit it and add in the following information.
 - Redhat portal user name
 - Password for the portal 
 - Entitalment pool (s) for RHEL 7 and RHEL 7 Ansible 2.6 *or versoin you plan on useing an OSE-3.11
If there is a desire to keep version locked down and the build is not using a Satellite server, versionlock can preform that function.
Verfify all extra tools you what to have installed 
If there is a desire to install a peticular version of OCP see the example in the file
 


