#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, prod"
  exit 1
fi
change_namespace.sh $1 mariadb
"${1}k.sh" create -f mariadb/mariadb-service.yaml
change_namespace.sh $1 default
