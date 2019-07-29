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
  echo "$0: you need to provide password value in mariadb/secrets/PASS.${1}.secret"
  exit 1
fi
vim --not-a-term -c "%s/PASS/${pass}/g" -c 'wq!' "$fn"
"${1}k.sh" create -f es/namespace.yaml
change_namespace.sh $1 redis
"${1}k.sh" -n mariadb create -f "$fn"
"${1}h.sh" -n redis redis stable/redis --set existingSecret=redis-secret
change_namespace.sh $1 default
