#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
./dev-analytics-api/secrets.sh
./dev-analytics-api/kubernetes-deploy.sh "$1"
