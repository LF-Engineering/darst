#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
change_namespace.sh $1 devstats
"${1}k.sh" delete svc backups-page-service
"${1}k.sh" delete deployment backups-page
change_namespace.sh $1 mariadb
"${1}k.sh" delete svc backups-page-service
"${1}k.sh" delete deployment backups-page
change_namespace.sh $1 default
