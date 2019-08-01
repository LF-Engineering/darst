#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}k.sh" create -f cluster-setup/role-readonly.yaml
"${1}k.sh" create -f cluster-setup/role-deploy.yaml
