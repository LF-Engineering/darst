#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
fn=/tmp/apply.yaml
function finish { 
  rm -f "$fn" 2>/dev/null
}
trap finish EXIT
i=0
for node in `"${1}k.sh" get nodes -l lfda=elastic -o=jsonpath='{range .items[*]}{.metadata.name}{"\n"}{end}'`
do
  cp es/node-local-storage.yaml "$fn"
  vim --not-a-term -c "%s/NODE/${node}/g" -c 'wq!' "$fn"
  name="es-data-${i}"
  vim --not-a-term -c "%s/NAME/${name}/g" -c 'wq!' "$fn"
  i=$((i+1))
  "${1}k.sh" apply -f "$fn"
done
