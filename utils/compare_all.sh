#!/bin/bash
# BUCKET=N - set bucket size, default is 10000 if not set
# SKIP_KEYS: metadata__updated_on,metadata__timestamp,metadata__enriched_on
# KEYS: grimoire_creation_date
# KEEP=1 - keep int.csv and ext.csv files
if  [ -z "$1" ]
then
  echo "$0: you need to specify internal ElasticSearch env: test, dev, stg, prod"
  exit 1
fi
if [ -z "$2" ]
then
  echo 'Please specify external ElasticSearch url as a 2nd argument'
  exit 2
fi
function cleanup {
  if [ -z "$KEEP" ]
  then
    rm -f int.csv ext.csv
  fi
}
trap cleanup EXIT
ext_es="${2}"
int_es="${1}"
echo "index,count" > ext.csv
echo "index,count" > int.csv
curl -XGET "${ext_es}/_cat/indices?v" 2>/dev/null | grep sds- | awk '{ print $3","$7 }' | sort >> ext.csv || exit 3
../es/get_es_indexes.sh "${int_es}" 2>/dev/null | grep sds- | awk '{ print $3","$7 }' | sort >> int.csv || exit 4
echo "Index counts data collected"
echo "First file is external ES, 2nd file is internal ES"
./compare_all.rb ext.csv int.csv
