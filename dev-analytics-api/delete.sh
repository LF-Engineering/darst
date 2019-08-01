#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
env=$1
if [ "$env" = "stg" ]
then
  env=staging
fi
if [ "$env" = "dev" ]
then
  env=develop
fi
"${1}k.sh" delete -n "dev-analytics-api-$env" secret ejson-keys
"${1}k.sh" delete ns "dev-analytics-api-$env"
