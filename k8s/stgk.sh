#!/bin/bash
KUBECONFIG=/root/.kube/kubeconfig_staging AWS_PROFILE=lfproduct-staging kubectl "$@"
