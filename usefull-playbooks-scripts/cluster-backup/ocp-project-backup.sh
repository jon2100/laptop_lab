#!/bin/bash 

# set -Exeuo pipefail

# Date: 08/01/2018
#
# Script Purpose: Create a backup of all projects on the OCP cluster.
# Version       : 1.01
#

#===============================================================================
#some scripts must be executed on cluster master node.
#===============================================================================

#Checking for login if no login using service account
# my_token=`cat /root/work/service_account/sffcusvcusr`
my_token=`cat /home/dude/cfg/oc-menu/sffcutoken`

handle ()
{
  if [[ `oc whoami` = "system:serviceaccount:sffcusvcproj:sffcusvusr" ]]; then
    oc logout 1> /dev/null
  fi
  exit
} # end of handle

trap 'handle; exit' INT TERM TSTP
if [[ -z $my_token ]]; then 
  clear
  printf "\n You must login to run script\n"
  exit
fi
oc_login=`oc whoami 2> /dev/null | wc -l`
if [[ $oc_login -lt 1 ]]; then
  clear
  oc login --token=$my_token 1> /dev/null
fi

#Login check done 

for pid in $(pidof -x `basename "$0"`); do
    [ $pid != $$ ] && echo "[$(date)] : `basename "$0"` : Process is already running with PID $pid" && exit 1
done

#Update this path to point to the backup location.
# readonly ARCHIVE_LOCATION="/opt/backups/master" && [ ! -d $ARCHIVE_LOCATION ] && mkdir -p $ARCHIVE_LOCATION
readonly ARCHIVE_LOCATION="/home/dude/cfg/backups/projects" && [ ! -d $ARCHIVE_LOCATION ] && mkdir -p $ARCHIVE_LOCATION

#Check the passed in token and validate.  If failure occurs, stop.
whoami=`oc whoami`

#Get the hostname of the OCP console
ocp_hostname_with_port=`oc version | grep Server | awk -F/ '{print $3}'`
ocp_hostname=`echo ${ocp_hostname_with_port} | awk -F: '{print $1}'`
echo "OCP Cluster: ${ocp_hostname}"

#Set the yaml backup path
temp_backup_path="${ocp_hostname}"

#Check for the project
project_list=`oc projects -q | grep -iv default | grep -iv openshift | grep -iv kube | grep -iv management-infra`
#Check to see that we got a response, if not just die.
if [ -z "$project_list" ]; then

  echo "=====================================================================
No projects found!  This should not happen, so something bad occured.
====================================================================="
  exit 1

fi

#Process the list of projects and export them if they are valid
readarray -t projects <<<"$project_list"
for project in "${projects[@]}"
do

  #check to see if the project is actually validation
  project_exists=`oc projects -q | grep ${project}`
  if [ -n "$project_exists" ]; then

    echo "Backing up project: ${project}"

    #Create a variable to hold
    yaml_dir="${temp_backup_path}/${project}"

    #Make the project directory
    mkdir -p ${yaml_dir}

    set +e
    #Export all bc,dc,is,route,svc yamls
#    oc get --export all -n ${project} -o yaml > ${yaml_dir}/project.yaml
    
    # Export build configs
    myout_bc=`oc get bc -n $project | awk 'NR!=1 {print $1}'`
    if [[ $myout_bc ]]; then
      for myout_bcs in $myout_bc
      do
        oc get --export bc $myout_bcs -n ${project} -o yaml > ${yaml_dir}/$myout_bcs-bc.yaml
      done
    else
      echo "no bc"
    fi

    # Export deployment config
    myout_dc=`oc get dc -n $project | awk 'NR!=1 {print $1}'`
    if [[ myout_dc ]]; then 
      for myout_dcs in $myout_dc
      do 
        oc get --export dc $myout_dcs -n ${project} -o yaml > ${yaml_dir}/$myout_dcs-dc.yaml
      done
    else 
      echo "no dc"
    fi

    # Export deployment
    myout_deploy=`oc get deployment -n $project | grep -v "\<0" | awk 'NR!=1 {print $1}' `
    if [[ $myout_deploy ]]; then
      for myout_deploys in $myout_deploy
      do
        oc get --export deployment $myout_deploys -n ${project} -o yaml > ${yaml_dir}/$myout_deploys-deployment.yaml
      done
    else
      echo "No deployment"
    fi

    # Export configMap
    myout_cm=`oc get cm -n $project | grep -v "\<0" | awk 'NR!=1 {print $1}'`
    if [[ $myout_cm ]]; then
      for myout_cms in $myout_cm
      do
        oc get --export cm $myout_cms -n ${project} -o yaml > ${yaml_dir}/$myout_cms.yaml
      done
    else
      echo "No configMap"
    fi

    # Export deamon set
    myout_ds=`oc get ds -n $project | grep -v "\<0" | awk 'NR!=1 {print $1}'`
    if [[ $myout_ds ]]; then
      for myout_dss in $myout_ds
      do 
        oc get --export ds $myout_dss -n ${project} -o yaml > ${yaml_dir}/$myout_dss-ds.yaml
      done
    else
      echo "No Daemon Set"
    fi 

    # Export replication controller 
    myout_rc=`oc get rc -n $project | grep -v "\<0" | awk 'NR!=1 {print $1}'`
    if [[ $myout_rc ]]; then
      for myout_rcs in $myout_rc
      do 
        oc get --export rc $myout_rcs -n ${project} -o yaml > ${yaml_dir}/$myout_rcs-rc.yaml
      done
    else
      echo "No Replication Controllers"
    fi
    
    # Export Service
    myout_svc=`oc get svc -n $project | awk 'NR!=1 {print $1}'`
    if [[ $myout_svc ]]; then 
      for myout_svcs in $myout_svc
      do
      oc get --export svc $myout_svcs -n ${project} -o yaml > ${yaml_dir}/$myout_svcs-service.yaml
      done
    else 
      echo "No service"
    fi
   
    # Export route
    myout_route=`oc get route -n $project | awk 'NR!=1 {print $1}'`
    if [[ $myout_route ]]; then 
      for myout_routes in $myout_route
      do
        oc get --export route $myout_routes -n ${project} -o yaml > ${yaml_dir}/$myout_routes-route.yaml
      done
    else
      echo "No route"
    fi

    # Export statefulsets
    myout_stateset=`oc get statefulset -n project | awk 'NR!=1 {print $1}'`
    if [[ $myout_stateset ]]; then
      for myout_statesets in $myout_stateset
      do
        oc get --export statefulset $myout_statesets -n ${project} -o yaml > ${yaml_dir}/$myout_statesets-statefulset.yaml
      done
    else 
      echo "No Stateful sets"
    fi

    # Export job
    myout_job=`oc get job -n $project | awk 'NR!=1 {print $1}'`
    if [[ $myout_job ]]; then 
      for myout_jobs in $myout_job
      do 
        oc get --export job $myout_jobs -n ${project} -o yaml > ${yaml_dir}/jobs-$myout_jobs.yaml
      done
    else
      echo "No Jobs"
    fi

    # Export cronjobs
    myout_cjob=`oc get cronjob -n $project | awk 'NR!=1 {print $1}'`
    if [[ $myout_cjob ]]; then
      for myout_cjobs in $myout_cjob
      do 
        oc get --export cronjob $myout_cjobs -n ${project} -o yaml > ${yaml_dir}/cronjob-$myout_cjobs.yaml
      done
    else 
      echo "No Cronjobs"
    fi

    #Export all the rolebindings
    myout_role=`oc get rolebindings -n $project | grep -iv system:deployers | grep -iv "system:image-builders" | grep -iv "system:image-pullers" | awk 'NR!=1 {print $1}'`
    if [[ $myout_role ]]; then
      for myout_roles in $myout_role
      do 
        # oc get --export rolebindings $myout_role -n ${project} -o yaml > ${yaml_dir}/$project-$myout_roles-rolebinding.yaml
        oc export rolebindings $myout_roles -n ${project} -o yaml > ${yaml_dir}/$project-$myout_roles-rolebinding.yaml
      done
    else 
      echo "No rolebindings"
    fi

    #Export any project serviceaccounts
    myout_sa=`oc get sa -n $project | grep -iv deployer | grep -iv default  | grep -iv builder | awk 'NR!=1 {print $1}'`
    if [[ $myout_sa ]]; then
      for myout_sas in $myout_sa
      do
        oc get --export serviceaccount $myout_sas -n ${project} -o yaml > ${yaml_dir}/serviceaccount-$myout_sas.yaml
        sed -i '/-token-/d;/-dockercfg-/d;' ${yaml_dir}/serviceaccount-$myout_sas.yaml
      done
    else
      echo "No SA"
    fi

    #Export any project secrets
    mysec=`oc get secrets -n $project | grep -iv builder-docker | grep -iv builder-token | grep -iv default | grep -iv deployer-docker | grep -iv deployer-token | awk 'NR!=1 {print $1}'`
    if [[ $mysec ]];then
      for mysecs in $mysec
      do
        oc get --export secret $mysecs -n ${project} -o yaml > ${yaml_dir}/$mysecs.yaml 2>/dev/null
      done
    else
      echo "No secrets"
    fi

    #Export any project pvc
    myout_pvc=`oc get pvc -n $project | awk 'NR!=1 {print $1}'`
    if [[ $myout_pvc ]]; then
      for pvcs in $myout_pvc
      do
        oc get --export pvc $pvcs -n ${project} -o yaml > ${yaml_dir}/$project-pvc-$pvcs.yaml
      done
    fi
    
    # network netnamespace 
    myout_netname=`oc get netnamespace $project | awk 'NR!=1 {print $3}'`
    if [[ $myout_netname == "[]" ]]; then
      echo "No Egress IP"
    else
      oc get --export netnamespace ${project} -o yaml > ${yaml_dir}/$project-$myout_netname.yaml
    fi
    # network policys 
    netpols=`oc get networkpolicy -n $project | awk 'NR!=1 {print $1}'`
# | grep -iv default | grep -iv same | grep -iv deny | awk 'NR!=1 {print $1}'`
    if [[ $netpols ]]; then 
      for mynetpol in $netpols
      do
        oc get --export networkpolicy $mynetpol -n $project -o yaml > ${yaml_dir}/$project-ingress-$mynetpol.yaml
      done
    else
      echo "No network policys"
    fi
   
    # Project egress policys 
    myegress_pol=`oc get egressnetworkpolicy -n $project | awk 'NR!=1 {print $1}'`
    if [[ $myegress_pol ]]; then
      for mypolegres in $myegress_pol
      do
         oc get --export egressnetworkpolicy $mypolegres -n $project -o yaml > ${yaml_dir}/$project-$mypolegres-egress.yaml
      done
    else
       echo "No egress network policy"
    fi

    # Project quotas
    myout_quotas=`oc get quota -n $project | awk 'NR!=1 {print $1}'`
    if [[ $myout_quotas ]]; then 
      for myout_quota in $myout_quotas
      do 
        oc get --export quota $myout_quota -n $project -o yaml > ${yaml_dir}/$project-$myout_quota-quota.yaml
      done
    else
      echo "No quota's"
    fi

    # Project limits 
    myout_limits=`oc get limits -n $project | awk 'NR!=1 {print $1}'`
    if [[ $myout_limits ]]; then 
      for myout_limit in $myout_limits
      do
        oc get --export limits $myout_limit -n $project -o yaml > ${yaml_dir}/$project-limits-$myout_limit.yaml
      done
    else 
      echo "No limits"
    fi

    # Project Backup
    oc export project $project -o yaml > ${yaml_dir}/$project-backup.yaml

    set -e
  else

    #Found an invalid project name, somehting bad may have happened, but we'll
    #just continue.
    echo "Project: ${project}, is not a valid project."

  fi
done

  # exporting clusterrolebindings 
  oc get --export clusterrolebindings -o yaml > ${temp_backup_path}/clusterrolebindings.yaml

# SCC Backups
myout_sccs=`oc get scc | awk 'NR!=1 {print $1}'`
if [[ $myout_sccs ]]; then
  for myout_scc in $myout_sccs
  do
    if [[ ! -d ${temp_backup_path}/scc ]]; then
      mkdir -p ${temp_backup_path}/scc
    fi
    oc get --export scc $myout_scc -o yaml > ${temp_backup_path}/scc/$myout_scc-scc.yaml
  done
else
   echo "No SCC"
fi

# Cleaning up files so they can be used
if [[ $temp_backup_path ]]; then 
  mydirs=`ls $temp_backup_path | grep -v .yaml`
  find ./$temp_backup_path -maxdepth 2 -type f -size 0 -exec rm -f {} \;
  for myfiles in $mydirs
  do
    pushd $temp_backup_path
    cd $myfiles
    myedits=`ls`
    for myedit in $myedits
    do
      sed -i '/imagePuLLSecrets\:/d;/secrets\:/d;/creationTimestamp\:/d;/selfLink\:/d;/netid\:/d;/generation\:/d;/resourcesVersion\:/d;/uid\:/d' $myedits
      #sed -i '/imagePuLLSecrets\:/d;/secrets\:/d;/creationTimestamp\:/d;/selfLink\:/d;/generation\:/d;/resourcesVersion\:/d;/uid\:/d' $myedits
    done
    popd
  done 
fi 

# Loging out service account 
svc_logout=`oc whoami`
if [[ $svc_logout = "system:serviceaccount:sffcusvcproj:sffcusvcusr" ]]; then 
  oc logout 1> /dev/null
else 
  echo "Not a service account" 
fi

#Now tar it.
tar_archive="${ARCHIVE_LOCATION}/${temp_backup_path}-$(date '+%Y%m%d-%H%M%S').tar.gz"
echo "Creating archive of project backups at: ${tar_archive}"
tar -czf ${tar_archive}  ${temp_backup_path}

echo "Cleanup yamls..."
if [[ ! -f $tar_archive ]]; then 
  echo "No backup file created"
else 
  rm -rf ${temp_backup_path}
fi
#Yea!
echo "Great Success"
