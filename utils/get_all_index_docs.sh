#!/bin/bash
# BUCKET=N - set bucket size, default is 10000 if not set
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
temp=temp.json
function cleanup {
  rm -f "$temp"
}
trap cleanup EXIT
function fexit {
  cat $temp
  echo "$1"
  exit $2
}
bucket=10000
if [ ! -z "$BUCKET" ]
then
  bucket=$BUCKET
fi
curl -XGET "${1}/${2}/_search?scroll=5m&size=${bucket}&pretty" > "$temp" 2>/dev/null || fexit 'Error initializing scroll' 4
scroll_id=`cat "$temp" | jq '._scroll_id'`
hits=`cat "$temp" | jq '.hits.total.value' 2>/dev/null`
if [ -z "$hits" ]
then
  hits=`cat "$temp" | jq '.hits.total'`
fi
if ( [ -z "$scroll_id" ] || [ -z "$hits" ] || [ "$scroll_id" = "null" ] || [ "$hits" = "null" ] )
then
  cat $temp
  echo "Scroll ID not found ($scroll_id) or no hits ($hits)"
  exit 5
fi
echo "Scroll ID: $scroll_id, Hits: $hits"
cnt=`cat "$temp" | jq '.hits.hits | length'`
if [ "$cnt" = "0" ]
then
  echo "Index $2 has no data, returning"
  echo "[]" > "$3"
  exit 0
fi
echo "Got $cnt records from initial call"
data=`cat "$temp" | jq '.hits.hits'`
data="${data:1:-1}"
all_data="$data"
loopz=0
while true
do
  json="{\"scroll\":\"5m\",\"scroll_id\":${scroll_id}}"
  curl -XGET -H 'Content-Type: application/json' "${1}/_search/scroll?pretty" -d "$json" > "$temp" 2>/dev/null || fexit "Error getting data: $json" 6
  cnt=`cat "$temp" | jq '.hits.hits | length'`
  if [ "$cnt" = "0" ]
  then
    echo "No more data, done $loopz scroll API loops (doesn't include initial $bucket fetch)"
    break
  fi
  data=`cat "$temp" | jq '.hits.hits'`
  data="${data:1:-1}"
  all_data="$all_data,$data"
  loopz=$((loopz+1))
  echo "Got $cnt records in #$loopz loop"
done
echo "[ $all_data ]" > "$3"
records=`cat "$3" | jq '. | length'`
echo "Done, saved $records records"
