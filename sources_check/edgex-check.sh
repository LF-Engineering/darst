#!/bin/bash
if [ -z "$1" ]
then
  echo "$0: required file containing list of repos to process"
  exit 1
fi
if [ -z "$2" ]
then
  echo "$0: required index name"
  exit 2
fi
if [ -z "$3" ]
then
  echo "$0: required field name to query"
  exit 3
fi
fn=result.csv
> "$fn"
for f in `cat "$1"`
do
  ./es/search_es_index.sh prod "$2" items "{\"match\":{\"$3\":\"$f\"}}"
  echo -n "$f status: "
  read n
  echo "$f,$n" >> "$fn"
done
cat "$fn"
echo 'Done'
