c1
oc patch -n openshift-storage storagecluster/ocs-storagecluster -p '{"spec":{"network":{"multiClusterService":{"clusterID":"local-cluster"}}}}' --type='merge'
oc patch -n openshift-storage storagecluster/ocs-storagecluster -p '{"spec":{"network":{"multiClusterService":{"enabled":true}}}}' --type='merge'
c2
oc patch -n openshift-storage storagecluster/ocs-storagecluster -p '{"spec":{"network":{"multiClusterService":{"clusterID":"cluster2"}}}}' --type='merge'
oc patch -n openshift-storage storagecluster/ocs-storagecluster -p '{"spec":{"network":{"multiClusterService":{"enabled":true}}}}' --type='merge'

