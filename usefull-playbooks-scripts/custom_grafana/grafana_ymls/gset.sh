oc apply -f custom-grafana-dashboard-compute.yaml
oc apply -f custom-grafana-dashboard-etcd.yaml
oc apply -f dashboard-pods.yml
oc apply -f dashboard-capacity.yml
oc apply -f dashboard-master-api.yml
oc apply -f dashboard-router.yml
oc apply -f dashboard-traffic.yml
oc apply -f grafana-sa.yml
oc apply -f grafana-clusterrolebinding.yml
oc apply -f grafana-custom-config-secret.yml
oc apply -f grafana-service.yml
oc apply -f grafana-route.yml
oc apply -f grafana-deployment-added-dashboard.yml

