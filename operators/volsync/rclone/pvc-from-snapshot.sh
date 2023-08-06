SNAPSHOT=$( oc get replicationdestination pvc -n dest --template={{.status.latestImage.name}} )
cat pvc-from-snapshot-template.yaml | sed  "s/snapshotToReplace/$SNAPSHOT/g" | oc create -f -

