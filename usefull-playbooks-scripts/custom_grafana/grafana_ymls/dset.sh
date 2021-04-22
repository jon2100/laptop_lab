oc delete deployment grafana-custom -n openshift-monitoring

oc delete cm custom-grafana-dashboard-compute -n openshift-monitoring
oc delete cm custom-grafana-dashboard-etcd -n openshift-monitoring
oc delete cm grafana-dashboard-capacity -n openshift-monitoring
oc delete cm grafana-dashboard-etcd -n openshift-monitoring
oc delete cm grafana-dashboard-master-api -n openshift-monitoring
oc delete cm grafana-dashboard-pods -n openshift-monitoring
oc delete cm grafana-dashboard-router -n openshift-monitoring
oc delete cm grafana-dashboard-traffic -n openshift-monitoring

oc delete sa grafana-custom -n openshift-monitoring

oc delete secret grafana-custom-config -n openshift-monitoring
oc delete secret grafana-custom-tls -n openshift-monitoring

oc delete svc grafana-custom -n openshift-monitoring

oc delete route grafana-custom -n openshift-monitoring
