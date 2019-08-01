#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
. env.sh "$1" || exit 1
"${1}k.sh" delete -n "dev-analytics-api-$ENV_NS" secret ejson-keys
"${1}k.sh" delete ns "dev-analytics-api-$ENV_NS"
