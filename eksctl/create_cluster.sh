#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
#eksctl create cluster --name=CNCFcluster --nodes=3 --kubeconfig=/root/.kube/config_cncf --tags node=devstats --node-volume-type=gp2 --node-volume-size=32 --version=1.12 --nodegroup-name=CNCFnodegroup --node-type=m5.2xlarge --node-ami=auto --ssh-access
"${1}eksctl.sh" get cluster
