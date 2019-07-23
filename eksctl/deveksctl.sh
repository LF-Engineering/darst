#!/bin/bash
KUBECONFIG=/root/.kube/kubeconfig_dev AWS_PROFILE=lfproduct-dev eksctl "$@"
