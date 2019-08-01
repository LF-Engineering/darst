#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
. env.sh "$1" || exit 1
cd ~/dev/dev-analytics-api/.circleci/deployments/$API_DIR || exit 3
context="`cat ~/.kube/kubeconfig_$KUBCONFIGE_SUFF | grep '^\- name: ' | awk '{print $3}'`"
echo $context
#kubernetes-deploy "$context" "arn:aws:eks:$region:$n:cluster/a-test-cluster" --template-dir=.
