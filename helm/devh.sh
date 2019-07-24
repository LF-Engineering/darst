#!/bin/bash
cmd=helm
if [ ! -z "$V2" ]
then
  cmd=helm2
fi
KUBECONFIG=~/.kube/kubeconfig_dev AWS_PROFILE=lfproduct-dev "$cmd" "$@"
