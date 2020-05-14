The name of the Install Folder can be any desired name. (Example: cfg/ OCPDeploy/ OCPInstall/)  

The inventory file or hosts file (name is interchangabel), dictates what hosts are nodes are in the cluster and their role. It also defines how the base of you cluster is to be setup. A OCP cluster does not have a 100% default and every envronment is different insure hosts and other static varables are set for the envirnment

The answer file is a shell, use the proper information in it. Located under group_vars/lab/