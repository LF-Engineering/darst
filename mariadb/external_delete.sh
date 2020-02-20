#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, prod"
  exit 1
fi
change_namespace.sh $1 mariadb
"${1}k.sh" delete svc mariadb-service-rw mariadb-service-all
change_namespace.sh $1 default
