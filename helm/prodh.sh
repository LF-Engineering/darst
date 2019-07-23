#!/bin/bash
cmd=helm
if [ ! -z "$V2" ]
then
  cmd=helm2
fi
KUBECONFIG=/root/.kube/kubeconfig_prod AWS_PROFILE=lfproduct-prod "$cmd" "$@"
