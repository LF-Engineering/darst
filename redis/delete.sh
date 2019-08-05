#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
change_namespace.sh $1 redis
"${1}h.sh" delete redis
change_namespace.sh $1 default
"${1}k.sh" delete ns redis
