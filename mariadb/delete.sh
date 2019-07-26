#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
change_namespace.sh $1 dev-analytics-elasticsearch
"${1}h.sh" -n mariadb delete mariadb
"${1}k.sh" -n mariadb delete secret mariadb
change_namespace.sh $1 default
