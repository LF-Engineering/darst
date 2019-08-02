#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if [ -z "$DOCKER_USER" ]
then
  echo "$0: you need to specify docker user via DOCKER_USER=..."
  exit 1
fi
. env.sh "$1" || exit 1
ns=/tmp/ns.yaml
fn=/tmp/apply.yaml
function finish {
  #rm -f "$ns" "$fn" 2>/dev/null
  cat "$ns" "$fn"
}
trap finish EXIT
cp dev-analytics-ui/namespace.yaml "$ns"
cp dev-analytics-ui/deployment.yaml "$fn"
cert=`cat "dev-analytics-ui/secrets/ssl-cert.$1.secret"`
host=`cat "dev-analytics-ui/secrets/hostname.$1.secret"`
if ( [ -z "$cert" ] || [ -z "$host" ] )
then
  echo "$0: you need to provide values in dev-analytics-ui/secrets/ssl-cert.$1.secret and dev-analytics-ui/secrets/hostname.$1.secret"
  exit 1
fi
vim --not-a-term -c "%s/SSL_CERT/${cert}/g" -c "%s/HOSTNAME/${host}/g" -c "%s/IMAGE/${DOCKER_USER}/g" -c 'wq!' "$fn"
vim --not-a-term -c "%s/ENV/${ENV_NS}/g" -c 'wq!' "$fn"
"${1}k.sh" create -f "$ns"
change_namespace.sh $1 dev-analytics-ui
"${1}k.sh" -n dev-analytics-ui create -f "$fn"
change_namespace.sh $1 default
