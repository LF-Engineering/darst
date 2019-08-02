#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
change_namespace.sh $1 dev-analytics-ui
"${1}k.sh" -n dev-analytics-ui delete deployment dev-analytics-ui-lb
change_namespace.sh $1 default
