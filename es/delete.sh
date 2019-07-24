#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}k.sh" config set-context --current --namespace=dev-analytics-elasticsearch
"${1}h.sh" delete dev-analytics-elasticsearch
"${1}k.sh" delete pvc elasticsearch-master-elasticsearch-master-0 elasticsearch-master-elasticsearch-master-1 elasticsearch-master-elasticsearch-master-2 elasticsearch-master-elasticsearch-master-3 elasticsearch-master-elasticsearch-master-4
"${1}k.sh" delete pv es-data-0 es-data-1 es-data-2 es-data-3 es-data-4
"${1}k.sh" config set-context --current --namespace=default
