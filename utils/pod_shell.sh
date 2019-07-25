#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod as a 1st argument"
  exit 1
fi
if [ -z "$2" ]
then
  echo "$0: you need to pass a pod name as an argument"
  exit 2
fi
"${1}k.sh" exec -it "$2" -- /bin/bash
