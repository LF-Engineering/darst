#!/bin/bash
# DRY=1 - will add --dry-run --debug flags
# ES_EXTERNAL=1 - use external ES address
env="$1"
op="$2"
if [ -z "$env" ]
then
  echo "$0: you need to provide env as 1st arg: test, dev, stg, prod"
  exit 1
fi
if [ -z "$op" ]
then
  echo "$0: you need to operation as 2nd arg: install, upgrade"
  exit 2
fi
if [ -z "$DOCKER_USER" ]
then
  echo "$0: you need to specify docker user via DOCKER_USER=..."
  exit 3
fi
if [ ! -z "$DRY" ]
then
  FLAGS="--dry-run --debug"
fi
. env.sh "$1" || exit 8
repository="${DOCKER_USER}/dev-analytics-kibana"
kibana_url="kibana\.${TF_DIR}\.lfanalytics\.io"
if [ -z "$ES_EXTERNAL" ]
then
  es_url="http://elasticsearch-master.dev-analytics-elasticsearch:9200"
else
  es_url="https://elastic.${TF_DIR}.lfanalytics.io"
fi
cert=`cat "es/secrets/ssl-cert.$1.secret"`
cert="${cert//\//\\\/}"
cert="${cert//\./\\\.}"
if [ -z "$cert" ]
then
  echo "$0: you need to provide value in kibana/secrets/ssl-cert.$1.secret"
  exit 4
fi
function finish {
  change_namespace.sh $env default
}
trap finish EXIT
"${1}k.sh" apply -f kibana/namespace.yaml
change_namespace.sh $1 kibana
if [ "$op" = "install" ]
then
  "${1}h.sh" install kibana ./kibana/kibana-chart $FLAGS -n kibana --set "image=$repository,elasticsearch.url=${es_url},hostname=${kibana_url},ingress.external.certArn=${cert}"
elif [ "$op" = "upgrade" ]
then
  "${1}h.sh" upgrade kibana ./kibana/kibana-chart $FLAGS -n kibana --reuse-values --set "image=$repository,elasticsearch.url=${es_url},hostname=${kibana_url},ingress.external.certArn=${cert}"
else
  echo "$0: unknown operation: $op"
  exit 9
fi
