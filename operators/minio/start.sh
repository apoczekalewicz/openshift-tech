oc create -f ./resources
oc describe -n minio svc minio-console | grep Ingress
