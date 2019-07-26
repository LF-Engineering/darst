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
cp mariadb/backups.yaml "$fn"
host=`cat mariadb/HOST.secret`
usr=`cat mariadb/ROOT_USER.secret`
vim --not-a-term -c "%s/SHUSER/${usr}/g" -c "%s/SHHOST/${host}/g" -c 'wq!' "$fn"
change_namespace.sh $1 mariadb
#"${1}k.sh" -n mariadb create -f mariadb/backups-pv.yaml
#"${1}k.sh" -n mariadb create -f "$fn"
change_namespace.sh $1 default
cat "$fn"
