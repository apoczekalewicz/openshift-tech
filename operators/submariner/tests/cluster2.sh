oc -n default run tmp-shell --rm -i --tty --image quay.io/submariner/nettest -- /bin/bash curl nginx.default.svc.clusterset.local:8080

