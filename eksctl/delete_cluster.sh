#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}eksctl.sh" delete nodegroup --name="dev-analytics-ng-${1}" --cluster "dev-analytics-kube-${1}"
"${1}eksctl.sh" delete cluster --name="dev-analytics-kube-${1}"
