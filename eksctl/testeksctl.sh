#!/bin/bash
KUBECONFIG=~/.kube/kubeconfig_test AWS_PROFILE=lfproduct-test eksctl "$@"
