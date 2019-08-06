#!/bin/bash
if [ -z "${ES_URL}" ]
then
  ES_URL='elasticsearch-master.dev-analytics-elasticsearch:9200'
fi
#curl -XGET "${ES_URL}/_cat/indices?v"
#"${1}k.sh" run --generator=run-pod/v1 curl-test-es -i --tty --restart=Never --rm --image="radial/busyboxplus:curl" --command "/usr/bin/curl" -- 'elasticsearch-master.dev-analytics-elasticsearch:9200'
"${1}k.sh" run --generator=run-pod/v1 curl-test-es -i --tty --restart=Never --rm --image="radial/busyboxplus:curl" -- /usr/bin/curl -XGET "${ES_URL}/_cat/indices?v"
