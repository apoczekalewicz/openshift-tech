Documentation:
https://access.redhat.com/documentation/en-us/red_hat_openshift_data_foundation/4.13/html-single/configuring_openshift_data_foundation_disaster_recovery_for_openshift_workloads/index#components-of-regional-dr-solution_rdr

- Na Obu klastrach dziala ODF
- Na HUB zainstalowany jest: ODF Multicluster Orchestrator
  Ten operator dogra jako zaleznosc: Openshift DR Hub Operator 

0) Aktywowac Submariner na obu klastrach 

2) SSL - Jesli na klastrach w ingress sa self-sign nalezy zadbac o to by kazda ze stron miala CA drugiego klastra

    Na pierwszym:
        oc get cm default-ingress-cert -n openshift-config-managed -o jsonpath="{['data']['ca-bundle\.crt']}" > primary.crt
    Na drugim:
    oc get cm default-ingress-cert -n openshift-config-managed -o jsonpath="{['data']['ca-bundle\.crt']}" > secondary.crt

    cat primary.crt secondary.crt > all.crt

    Na obu:
    oc create --dry-run=client -n openshift-config cm user-ca-bundle -o yaml --from-file=ca-bundle.crt=./all.crt | oc create -f -
    oc patch proxy cluster --type=merge  --patch='{"spec":{"trustedCA":{"name":"user-ca-bundle"}}}

# skrypt scripts/ssl/ssl.sh

3*) GDY JEST GLOBALNET -  Korelacja Submarinera z StorageCluster na kazdym z nodow:

    Na obu:
        oc edit storagecluster -o yaml -n openshift-storage

        spec:
          network:
            multiClusterService:
              clusterID: <clustername>
              enabled: true

# skrypt scripts/storagecluster-submariner/patch.sh

3a) OSD sie zrestartuja + MONy failover

# skrypt: scripts/odf/pods.sh

3b) Sprawdzenie czy sa ServiceExport (dla monow i osdkow):

oc get serviceexport -n openshift-storage

# skrypt scripts/serviceexport/check.sh


-- koniec SETUPu --


Wgranie aplikacji:
app/ <- albo z subscription cephfs albo ArgoCD z RBD


-----------------------

Ochrona dr/

drpolicy - definiuje grupe klastrow i czas synchronizacji (minimalny to 1min) - obiekt jest globalny i moze byc uzywany w wielu ochronach
drplacementcontrol:
    - korelacja drpolicy
    - korelacja z placementem (wszystko czego dotyka dany placement objete jest ochrona DR!!!! nie definiujemy tak naprawde ochrony per "aplikacja" a per placement, wiec placement musi byc unikalny dla aplikacji chronionej)
    - prefferedCluster
    - pvcSelector - chronione sa tylko wybrane PVC z danym labelem!


Wykonywanie akcji to modyfikacja drplacementcontrol o takie elementy:

spec:
  preferredCluster: cluster2
  action: "Relocate"

gdzie action to moze byc Relocate lub Failover







----------------

usuwanie aplikacji poza normalnym usunieciem to wejscie na HUB cluster w installed operators w namespace danej aplikacji - operator DR HUB i usuniecie CR drplacementpolicy
