#!/bin/bash
KUBECONFIG=~/.kube/kubeconfig_prod AWS_PROFILE=lfproduct-prod eksctl "$@"
