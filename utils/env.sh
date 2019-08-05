#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if [ "$1" = "test" ]
then
  export AWS_PROFILE=lfproduct-test
  export KUBECONFIG=~/.kube/kubeconfig_test
  export KUBCONFIGE_SUFF=test
  export TF_DIR=test
  export API_DIR=test
  export ENV_NS=test
  export RAILS_ENV=test
  export CMD_ROOT=$1
elif [ "$1" = "dev" ]
then
  export AWS_PROFILE=lfproduct-dev
  export KUBECONFIG=~/.kube/kubeconfig_dev
  export KUBCONFIGE_SUFF=dev
  export TF_DIR=dev
  export API_DIR=develop
  export ENV_NS=develop
  export RAILS_ENV=development
  export CMD_ROOT=$1
elif [ "$1" = "stg" ]
then
  export AWS_PROFILE=lfproduct-staging
  export KUBECONFIG=~/.kube/kubeconfig_staging
  export KUBCONFIGE_SUFF=staging
  export TF_DIR=staging
  export API_DIR=staging
  export ENV_NS=staging
  export RAILS_ENV=staging
  export CMD_ROOT=$1
elif [ "$1" = "prod" ]
then
  export AWS_PROFILE=lfproduct-prod
  export KUBECONFIG=~/.kube/kubeconfig_prod
  export KUBCONFIGE_SUFF=prod
  export TF_DIR=prod
  export API_DIR=prod
  export ENV_NS=prod
  export RAILS_ENV=production
  export CMD_ROOT=$1
else
  echo "$0: unknown env '$1'"
  exit 2
fi
