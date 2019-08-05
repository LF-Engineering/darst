#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}k.sh" create -f redis/namespace.yaml
change_namespace.sh $1 redis
"${1}h.sh" -n redis install redis stable/redis -f redis/custom.yaml --set "usePassword=false,master.nodeSelector.lfda=grimoire,master.persistence.storageClass=openebs-hostpath,master.persistence.size=4Gi,master.resources.requests.cpu=250m,master.resources.requests.memory=256Mi,master.resources.limits.cpu=2000m,master.resources.limits.memory=2Gi,slave.nodeSelector.lfda=grimoire,slave.persistence.storageClass=openebs-hostpath,slave.persistence.size=4Gi,slave.resources.requests.cpu=250m,slave.resources.requests.memory=256Mi,slave.resources.limits.cpu=2000m,slave.resources.limits.memory=2Gi"
change_namespace.sh $1 default
