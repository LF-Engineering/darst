#!/bin/bash
KUBECONFIG=~/.kube/kubeconfig_dev AWS_PROFILE=lfproduct-dev eksctl "$@"
