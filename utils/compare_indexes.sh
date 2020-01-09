#!/bin/bash
# BUCKET=N - set bucket size, default is 10000 if not set
# SKIP_KEYS: metadata__updated_on,metadata__timestamp,metadata__enriched_on
# KEYS: grimoire_creation_date
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
if [ -z "$3" ]
then
  echo 'Please specify index name as a 3rd argument'
  exit 3
fi
index="${3}"
fn="${index}.json"
ext_es="${2}"
int_es="${1}"
echo "Saving external ES index as external/${fn}"
./get_all_index_docs.sh "${ext_es}" "${index}" "${fn}" || exit 4
mv "${fn}" "external/${fn}"
echo "Saving internal ES index as internal/${fn}"
./get_all_index_docs_internal.sh "${int_es}" "${index}" "${fn}" || exit 5
mv "${fn}" "internal/${fn}"
echo "Comparing 1st file (external) with 2nd file (internal)"
./compare_indexes.rb "internal/${fn}" "external/${fn}"
