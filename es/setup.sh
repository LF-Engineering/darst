#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
fn=/tmp/apply.yaml
function finish {
  # cat "$fn"
  rm -f "$fn" 2>/dev/null
}
trap finish EXIT
cp es/lb.yaml "$fn"
cert=`cat "es/secrets/ssl-cert.$1.secret"`
host=`cat "es/secrets/hostname.$1.secret"`
cert="${cert//\//\\\/}"
cert="${cert//\./\\\.}"
host="${host//\./\\\.}"
if ( [ -z "$cert" ] || [ -z "$host" ] )
then
  echo "$0: you need to provide values in es/secrets/ssl-cert.$1.secret and es/secrets/hostname.$1.secret"
  exit 1
fi
vim --not-a-term -c "%s/SSLCERT/${cert}/g" -c "%s/HOSTNAME/${host}/g" -c "%s/IMAGE/${DOCKER_USER}\/dev-analytics-ui/g" -c 'wq!' "$fn"
"${1}h.sh" repo add elastic https://helm.elastic.co
"${1}k.sh" create -f es/namespace.yaml
change_namespace.sh $1 dev-analytics-elasticsearch
# This was needed when raw 'local-storage' was used, but we switched to OpenEBS.
# ./es/setup_local_storage.sh $1
"${1}h.sh" -n dev-analytics-elasticsearch install dev-analytics-elasticsearch elastic/elasticsearch --set 'imageTag=6.8.1,replicas=5,esJavaOpts=-Xms6g -Xmx6g,nodeSelector.lfda=elastic,resources.requests.cpu=1500m,resources.requests.memory=6Gi,resources.limits.cpu=2000m,resources.limits.memory=7Gi,volumeClaimTemplate.storageClassName=openebs-hostpath,volumeClaimTemplate.resources.requests.storage=400Gi'
"${1}k.sh" -n dev-analytics-elasticsearch create -f "$fn"
change_namespace.sh $1 default
