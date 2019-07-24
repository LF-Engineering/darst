#!/bin/bash
cmd=helm
if [ ! -z "$V2" ]
then
  cmd=helm2
fi
KUBECONFIG=~/.kube/kubeconfig_staging AWS_PROFILE=lfproduct-staging "$cmd" "$@"
