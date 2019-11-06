#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
for f in `cat stuff/indices.txt`
do
  echo "$f"
  ./es/delete_es_index.sh "$1" "$f"
done
