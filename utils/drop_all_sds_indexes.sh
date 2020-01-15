#!/bin/bash
# FILTER=pull_request - additional filter to choose indexes to delete
if [ -z "$1" ]
then
  echo 'Please specify elasticsearch url as a first argument'
  exit 1
fi
if [ -z "$FILTER" ]
then
  indices=`curl "${1}/_cat/indices?v" 2>/dev/null | sort | grep 'sds-' | awk '{print $3}'`
else
  indices=`curl "${1}/_cat/indices?v" 2>/dev/null | sort | grep 'sds-' | grep "$FILTER" | awk '{print $3}'`
fi
if [ -z "$indices" ]
then
  echo "No indices found"
  exit 2
fi
echo "Dropping $indices"
for index in $indices
do
  curl -XDELETE "${1}/${index}" >/dev/null 2>/dev/null || exit 3
  echo "Dropped: $index"
done
echo 'Done'
