c1
oc get cm default-ingress-cert -n openshift-config-managed -o jsonpath="{['data']['ca-bundle\.crt']}" > primary.crt
c2
oc get cm default-ingress-cert -n openshift-config-managed -o jsonpath="{['data']['ca-bundle\.crt']}" > secondary.crt

cat primary.crt secondary.crt > all.crt
oc create --dry-run=client -n openshift-config cm user-ca-bundle -o yaml --from-file=ca-bundle.crt=./all.crt > cm-clusters-crt.yaml

c1
oc create -f cm-clusters-crt.yaml
oc patch proxy cluster --type=merge  --patch='{"spec":{"trustedCA":{"name":"user-ca-bundle"}}}'
c2
oc create -f cm-clusters-crt.yaml
oc patch proxy cluster --type=merge  --patch='{"spec":{"trustedCA":{"name":"user-ca-bundle"}}}'

rm *.crt *.yaml
