# grafana-custom
Custom Grafana for OpenShift 3.11

By default OpenShift 3.11 Grafana is a read-only instance. Many organizations may want to add new custom dashboards. This custom grafana will interact with existing Prometheus and will also add all out-of-the-box dashboards plus few more interesting dashboards which may require from day to day operation. Custom Grafana pod uses OpenShift oAuth to authenticate users and assigns "Admin" role to all users so that users can create their own dashboards for additional monittoring.

* Clone the repository and switch into the directory. Log in as a cluster-admin user and switch to openshift-monitroing project:

* Install with ansible  
```
oc project openshift-monitoring  
ansible-plybook -i {{ inventory/hosts }} custom-grafana/custom-grafana-setup.yaml  
``` 
* Manually Install  
```
cd grafana-custom/custom_grafana_ymls  
oc project openshift-monitoring  
```
ansible-plybook -i {{ inventory/hosts }} custom-grafana-setup.yaml  
* Create a Service Account named grafana-custom:  
```
oc create -f grafana-sa.yml
```

* Assign existing "grafana" role to grafana-custom Service Account:
```
oc create -f grafana-clusterrolebinding.yml
```

* Create a secret for grafana-custom configuration:
```
oc create -f grafana-custom-config-secret.yml
```

* Create few custom dashboards. All existing OpenShift dashboards will be imported automatically:
```
oc create -f dashboard-capacity.yml
oc create -f dashboard-master-api.yml
oc create -f dashboard-pods.yml
oc create -f dashboard-traffic.yml
oc create -f custom-grafana-dashboard-etcd.yml  
oc create -f custom-grafana-dashboard-compute.yml  
```

* Create a service for grafana-custom:
```
oc create -f grafana-service.yml
```

* Create a route for the grafana-custom:
```
oc create -f grafana-route.yml
```

* Finally, create the grafana-custom Pod:
```
oc apply -f grafana-deployment-added-dashboard.yml   
```
* This would be the yml to use if you want to have storage assignd to the grafana po, validate before use  
```
oc apply -f grafana-deployment-when-using-storage.yml  
```

* gset and dset will install and uninstall custom grafana  
```
./gset or ./dset  
Verify the deployment.yml that is being used  
```

---
Refrance:  
https://github.com/shah-zobair/grafana-custom  
