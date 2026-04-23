#!/bin/bash
line_count=$(oc get namespace -o custom-columns=":metadata.name" | egrep -c "showroom-${GUID}-1-user")

for ((i=1; i<=line_count; i++)); do
    NS="showroom-${GUID}-1-user"$i
    oc scale -n $NS deploy/showroom --replicas=0
    sleep 1
    oc patch -n $NS deploy/showroom --patch='{"spec":{"template":{"spec":{"containers": [{"name": "content","env": [{"name": "GIT_REPO_URL", "value": "https://github.com/shayashi1225/ocp4-getting-started-showroom"}, {"name": "GIT_REPO_REF", "value": "main"}]}]}}}}'
    oc patch -n $NS deploy/showroom --patch='{"spec":{"template":{"spec":{"initContainers": [{"name": "git-cloner","env": [{"name": "GIT_REPO_URL", "value": "https://github.com/shayashi1225/ocp4-getting-started-showroom"}, {"name": "GIT_REPO_REF", "value": "main"}]}]}}}}'
    oc scale -n $NS deploy/showroom --replicas=1
done