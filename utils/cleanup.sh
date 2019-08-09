#!/bin/bash
# DRY=1 (only display what would be done)
if [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if [ -z "$2" ]
then
  echo "$0: please provide namespace name as a 2nd argument"
  exit 2
fi
if [ -z "$3" ]
then
  echo "$0: please provide pod status, for exampel 'Failed'"
  exit 3
fi
list=`"${1}k.sh" get po -n "$2" -o=jsonpath='{range .items[*]}{.metadata.name}{";"}{.status.phase}{"\n"}{end}'`
pods=""
for data in $list
do
  IFS=';'
  arr=($data)
  unset IFS
  pod=${arr[0]}
  sts=${arr[1]}
  if [ "$sts" = "$3" ]
  then
    pods="${pods} ${pod}"
  fi
done
if [ ! -z "$pods" ]
then
  if [ -z "$DRY" ]
  then
    echo "Deleting pods: ${pods}"
    "${1}k.sh" -n "$2" delete pod ${pods}
  else
    echo "Would delete pods: ${pods}"
  fi
fi
