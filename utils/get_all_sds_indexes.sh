#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod as a 1st argument"
  exit 1
fi
./es/get_es_indexes.sh "$1" | sort | grep sds | awk '{print $3}'
