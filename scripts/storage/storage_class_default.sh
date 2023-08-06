#!/bin/bash

if [[ "$#" -ne "1" ]]
then
	echo "Usage: $0 <sc>"
	exit 1
fi

for SC in $( oc get storageclass -o name )
do
 	oc patch $SC -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "false"}}}'
done

oc patch storageclass $1 -p '{"metadata": {"annotations": {"storageclass.kubernetes.io/is-default-class": "true"}}}'
