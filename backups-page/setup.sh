#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}k.sh" create -f backups-page/namespace.yaml
change_namespace.sh $1 backups
"${1}k.sh" create -f backups-page/backups-page.yaml
change_namespace.sh $1 default
