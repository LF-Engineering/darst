#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
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
ts=`date +'%s%N'`
pod="es-shell-internal-${ts}"
k="${1}k.sh"
function finish {
  "$k" delete --wait=false pod "$pod"
}
trap finish EXIT
if [ -z "${ES_URL}" ]
then
  ES_URL='elasticsearch-master.dev-analytics-elasticsearch:9200'
fi
"${1}k.sh" run --generator=run-pod/v1 --image="cfmanteiga/alpine-bash-curl-jq" "$pod" --env="ES_URL=${ES_URL}" -- /bin/sleep 3600s
while [ ! "`${1}k.sh get po | grep "$pod" | awk '{ print $3 }'`" = "Running" ]
do
  echo "Waiting for pod to be running..."
  sleep 1
done
"${1}k.sh" cp get_all_index_docs.sh "${pod}:get_all_index_docs.sh"
# echo "${1}k.sh exec -it $pod -- ./get_all_index_docs.sh $ES_URL $2 $3"
"${1}k.sh" exec -it "$pod" -- ./get_all_index_docs.sh "$ES_URL" "$2" "$3"
"${1}k.sh" cp "${pod}:${3}" "$3"
