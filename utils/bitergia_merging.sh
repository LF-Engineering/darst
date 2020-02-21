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
proj1="${1}"
proj2="${proj1}"
if [ ! -z "${2}" ]
then
  proj2="${2}"
fi
echo "Bitergia indices ${proj1}:"
curl "${ES_URL}/_cat/indices?v" 2>/dev/null | sort | grep bitergia- | grep "${proj1}"
echo "SDS indices ${proj2}:"
curl "${ES_URL}/_cat/indices?v" 2>/dev/null | sort | grep sds- | grep "${proj2}"
echo "Aliases ${proj1}:"
curl "${ES_URL}/_cat/aliases?v" 2>/dev/null | sort | grep "${proj1}"
if [ ! "${proj1}" = "${proj2}" ]
then
  echo "Aliases ${proj2}:"
  curl "${ES_URL}/_cat/aliases?v" 2>/dev/null | sort | grep "${proj2}"
fi
