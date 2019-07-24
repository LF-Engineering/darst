#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}k.sh" config set-context --current --namespace=dev-analytics-elasticsearch
"${1}h.sh" delete pv es-data-0 es-data-1 es-data-2 es-data-3 es-data-4
"${1}h.sh" delete dev-analytics-elasticsearch
"${1}k.sh" config set-context --current --namespace=default
