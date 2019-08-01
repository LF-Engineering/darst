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
envd=$env
if [ "$denv" = "develop" ]
then
  denv=dev
fi
cd ~/dev/dev-analytics-terraform-stash || exit 2
# FIXME: prod has two folders, we're choosing first via 'head -n 1'
dir_name=`ls -d *.$denv | head -n 1`
echo $dir_name
if [ -z "$dir_name" ]
then
  echo "$0: cannot find deployment directory for env $1"
  exit 3
fi
# FIXME: note that is is a very hacky way of getting AWS account and region - but I want to avoid hardcoding anything in a public repo
IFS=\. read -a ary <<<"$dir_name"
region="${ary[0]}"
n="${ary[1]}"
cd "~/dev/dev-analytics-api/.circleci/deployments/$env" || exit 3
export KUBECONFIG="/root/.kube/kubeconfig_$1"
export AWS_PROFILE="lfproduct-$1"
kubernetes-deploy "dev-analytics-api-$env" "arn:aws:eks:$region:$n:cluster/a-test-cluster" --template-dir=.
