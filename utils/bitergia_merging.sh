#!/bin/bash
if [ -z "$ES_URL" ]
then
  echo "$0: please specify ES_URL=..."
  exit 1
fi
if [ -z "${1}" ]
then
  echo "$0: please specify project name as a 1st arg"
  exit 2
fi
echo "Bitergia indices:"
curl "${ES_URL}/_cat/indices?v" 2>/dev/null | sort | grep bitergia- | grep "${1}"
echo "SDS indices:"
curl "${ES_URL}/_cat/indices?v" 2>/dev/null | sort | grep sds- | grep "${1}"
echo "Aliases:"
curl "${ES_URL}/_cat/aliases?v" 2>/dev/null | sort | grep "${1}"
