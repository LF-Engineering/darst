#!/bin/bash
KUBECONFIG=/root/.kube/kubeconfig_prod AWS_PROFILE=lfproduct-prod kubectl "$@"
