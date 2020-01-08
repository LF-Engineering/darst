#!/bin/bash
if [ -z "$1" ]
then
  echo 'Please specify elasticsearch url as a first argument'
  exit 1
fi
if [ -z "$2" ]
then
  echo 'Please specify index name as a second argument'
  exit 2
fi
if [ -z "$3" ]
then
  echo 'Please specify output filename as a third argument'
  exit 3
fi
bucket=30
temp=temp.json
function cleanup {
  rm -f "$temp"
}
trap cleanup EXIT
function fexit {
  echo "$1"
  exit $2
}
curl -XGET "${1}/${2}/_search?scroll=5m&size=${bucket}&pretty" > "$temp" 2>/dev/null || fexit 'Error initializing scroll' 4
scroll_id=`cat "$temp" | jq '._scroll_id'`
hits=`cat "$temp" | jq '.hits.total.value'`
if ( [ -z "$scroll_id" ] || [ -z "$hits" ] || [ "$scroll_id" = "null" ] || [ "$hits" = "null" ] )
then
  echo "Scroll ID not found ($scroll_id) or no hits ($hits)"
  exit 5
fi
echo "Scroll ID: $scroll_id, Hits: $hits"
data=`cat "$temp" | jq '.hits.hits | length'`
echo "Count: $data"
from=0
while true
do
  json="{\"scroll\":\"5m\",\"scroll_id\":${scroll_id}}"
  curl -XGET -H 'Content-Type: application/json' "${1}/_search/scroll?pretty" -d "$json" > "$temp" 2>/dev/null || fexit "Error getting data: $json" 6
  data=`cat "$temp" | jq '.hits.hits | length'`
  echo "Count: $data"
  read a
done
