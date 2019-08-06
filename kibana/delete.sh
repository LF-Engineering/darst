#!/bin/bash
env="$1"
if [ -z "$env" ]
then
  echo "$0: you need to provide env as 1st arg: test, dev, stg, prod"
  exit 1
fi
change_namespace.sh $1 kibana
"${1}h.sh" delete kibana
change_namespace.sh $1 default
"${1}k.sh" delete ns kibana
