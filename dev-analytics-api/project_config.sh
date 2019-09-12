#!/bin/bash
# NO_DNS=1 - use internal API server (raw AWS ELB) instead of external DNS
if [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if [ -z "$2" ]
then
  echo "$0: you need to specify project as a second arg"
  exit 2
fi
. env.sh "$1" || exit 1
api="https://api.${TF_DIR}.lfanalytics.io"
if [ ! -z "$NO_DNS" ]
then
  api=`"${1}k.sh" -n "dev-analytics-api-$1" get svc | grep dev-analytics-api-lb | head -n 1 | awk '{ print $4 }'`
else
  if [ "$1" = "prod" ]
  then
    api="https://api.lfanalytics.io"
  fi
fi
api="${api}/api/internal/grimoire/configuration/$2"
for type in mordred environment aliases projects credentials
do
  echo '======================================================='
  echo "${api}/${type}:"
  echo '======================================================='
  if [ "$type" = "mordred" ]
  then
    curl -s "${api}/${type}" | jq -r .rendered
  else
    curl -s "${api}/${type}" | jq
  fi
done
