#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}k.sh" create -f es/namespace.yaml
change_namespace.sh $1 redis
"${1}h.sh" -n redis redis stable/redis --set
change_namespace.sh $1 default
