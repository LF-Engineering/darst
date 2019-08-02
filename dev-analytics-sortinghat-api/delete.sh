#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
change_namespace.sh $1 sortinghat-api
"${1}k.sh" -n sortinghat-api delete deployment sortinghat-api
"${1}k.sh" -n sortinghat-api delete svc sortinghat-api-endpoint
change_namespace.sh $1 default
"${1}k.sh" delete ns sortinghat-api
