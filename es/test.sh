#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}k.sh" run --generator=run-pod/v1 curl-test-es -i --tty --restart=Never --rm --image="radial/busyboxplus:curl" --command "/usr/bin/curl" -- 'elasticsearch-master.dev-analytics-elasticsearch:9200'
#"${1}k.sh" delete pod curl-test-es
