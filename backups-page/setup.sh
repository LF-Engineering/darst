#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
#change_namespace.sh $1 devstats
#"${1}k.sh" create -f backups-page/backups-page-postgres.yaml
change_namespace.sh $1 mariadb
"${1}k.sh" create -f backups-page/backups-page-mariadb.yaml
change_namespace.sh $1 default
