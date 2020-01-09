#!/bin/bash
if [ -z "$1" ]
then
  echo 'Please specify elasticsearch url as a first argument'
  exit 1
fi
n=5000
if [ ! -z "$2" ]
then
  n=$2
fi
err=err.txt
function cleanup {
  rm -f "$err"
}
trap cleanup EXIT
function fexit {
  cat $err
  echo "$1"
  exit $2
}
json="{\"persistent\":{\"search.max_open_scroll_context\":${n}},\"transient\":{\"search.max_open_scroll_context\":${n}}}"
curl -XPUT -H 'Content-Type: application/json' "${1}/_cluster/settings" -d "$json" 2>"$err" || fexit "Error setting max scrolls number: $json" 2
curl "${1}/_cluster/settings?pretty" 2>"$err" | grep max_open_scroll
