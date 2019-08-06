#!/bin/bash
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
api=`"${1}k.sh" -n "dev-analytics-api-$1" get svc | grep dev-analytics-api-lb | awk '{ print $4 }'`
api="${api}/api/internal/grimoire/configuration/$2"
for type in mordred environment aliases projects credentials
do
  echo '======================================================='
  echo "${type}:"
  echo '======================================================='
  if [ "$type" = "mordred" ]
  then
    curl -s "${api}/${type}" | jq -r .rendered
  else
    curl -s "${api}/${type}" | jq
  fi
done
