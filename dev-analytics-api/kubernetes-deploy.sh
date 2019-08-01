#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
. env.sh "$1" || exit 1
cd ~/dev/dev-analytics-api/.circleci/deployments/$API_DIR || exit 3
context="`cat ~/.kube/kubeconfig_$KUBCONFIGE_SUFF | grep '^\- name: ' | awk '{print $3}'`"
kubernetes-deploy "dev-analytics-api-$ENV_NS" "$context" --template-dir=.
