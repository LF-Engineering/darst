#!/bin/bash
KUBECONFIG=/root/.kube/kubeconfig_test AWS_PROFILE=lfproduct-test kubectl "$@"
