This playbook is to check comminly missed host configurations

Checks include:
- swap disabled
- NetworkManager installed
- if NM_CONTROLLED=yes is set
- ipv4 is set *ether in /etc/sysctl.conf or /etc/sysctl.c/99-openshift.conf
- hostnames (insure it's fqdn) 
- Validate DNS and PTR records for nodes 
- checks resolv.conf domain count *should be less that 5 - OCP add 1 to resolv and 1 to dnsmasq
- checks if mem over commit is set *Not every cluster needs to have this set
- Performs IP validation DNS lookup, Currnet IP of host, nslookup of IP on host

Usage:
ansible-playbook -i <inventory_file> preflight/preflightcheck.yml
