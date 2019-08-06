#!/bin/bash
if [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if [ -z "$2" ]
then
  echo "$0: you need to specify API URL as a second arg"
  echo "$0: for example 'api/internal/grimoire/configuration/linux-kernel/mordred'"
  exit 2
fi
api=`"${1}k.sh" -n "dev-analytics-api-$1" get svc | grep dev-analytics-api-lb | awk '{ print $4 }'`
curl -s "${api}/$2"
