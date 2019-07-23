#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
#"${1}eksctl.sh" create cluster --name="dev-analytics-kube-${1}" --nodes=12 --kubeconfig="/root/.kube/kubeconfig_${1}" --tags node=devstats --node-volume-type=gp2 --node-volume-size=20 --version=1.13 --nodegroup-name="dev-analytics-ng-${1}" --node-type=m5.2xlarge --node-ami=auto --ssh-access
"${1}eksctl.sh" create cluster --name="dev-analytics-kube-${1}" --nodes=12 --kubeconfig="/root/.kube/kubeconfig_${1}" --tags node=devstats --node-volume-type=gp2 --node-volume-size=20 --version=1.13 --nodegroup-name="dev-analytics-ng-${1}" --node-type=m5.xlarge --node-ami=auto --ssh-access
