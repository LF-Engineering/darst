#!/bin/bash
KUBECONFIG=~/.kube/kubeconfig_staging AWS_PROFILE=lfproduct-staging kubectl "$@"
