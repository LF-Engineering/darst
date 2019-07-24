#!/bin/bash
cmd=helm
if [ ! -z "$V2" ]
then
  cmd=helm2
fi
KUBECONFIG=~/.kube/kubeconfig_test AWS_PROFILE=lfproduct-test "$cmd" "$@"
