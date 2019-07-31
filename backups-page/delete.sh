#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
change_namespace.sh $1 backups
"${1}h.sh" delete dev-analytics-elasticsearch
"${1}k.sh" delete deployment backups-page
change_namespace.sh $1 default
