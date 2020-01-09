#!/bin/bash
if [ -z "$1" ]
then
  echo 'Please specify elasticsearch url as a first argument'
  exit 1
fi
indices=`curl "${1}/_cat/indices?v" 2>/dev/null | sort | grep 'sds-' | awk '{print $3}'`
if [ -z "$indices" ]
then
  echo "No indices found"
  exit 2
fi
for index in $indices
do
  curl -XDELETE "${1}/${index}" >/dev/null 2>/dev/null || exit 3
  echo "Dropped: $index"
done
echo 'Done'
