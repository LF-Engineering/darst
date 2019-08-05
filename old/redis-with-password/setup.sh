#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
fn=/tmp/apply.yaml
function finish {
  rm -f "$fn" 2>/dev/null
}
trap finish EXIT
cp redis/secret.yaml "$fn"
pass=`cat "redis/secrets/PASS.${1}.secret" | base64`
if [ -z "$pass" ]
then
  echo "$0: you need to provide password value in redis/secrets/PASS.${1}.secret"
  exit 1
fi
vim --not-a-term -c "%s/PASS/${pass}/g" -c 'wq!' "$fn"
"${1}k.sh" create -f redis/namespace.yaml
change_namespace.sh $1 redis
"${1}k.sh" -n redis create -f "$fn"
"${1}h.sh" -n redis install redis stable/redis --set "existingSecret=redis-secret,master.nodeSelector.lfda=grimoire,master.persistence.storageClass=openebs-hostpath,master.persistence.size=4Gi,master.resources.requests.cpu=250m,master.resources.requests.memory=256Mi,master.resources.limits.cpu=2000m,master.resources.limits.memory=2Gi,slave.nodeSelector.lfda=grimoire,slave.persistence.storageClass=openebs-hostpath,slave.persistence.size=4Gi,slave.resources.requests.cpu=250m,slave.resources.requests.memory=256Mi,slave.resources.limits.cpu=2000m,slave.resources.limits.memory=2Gi"
change_namespace.sh $1 default
