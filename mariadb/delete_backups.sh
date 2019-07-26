#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
change_namespace.sh $1 mariadb
"${1}k.sh" -n mariadb delete cj mariadb-backups
"${1}k.sh" -n mariadb delete pvc mariadb-backups
change_namespace.sh $1 default
