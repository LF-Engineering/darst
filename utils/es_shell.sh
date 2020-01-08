#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if [ -z "${ES_URL}" ]
then
  ES_URL='elasticsearch-master.dev-analytics-elasticsearch:9200'
fi
"${1}k.sh" run --generator=run-pod/v1 bash-curl-jq--es -i --tty --restart=Never --rm --image="cfmanteiga/alpine-bash-curl-jq" -- /bin/bash
