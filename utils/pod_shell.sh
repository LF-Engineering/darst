#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod as a 1st argument"
  exit 1
fi
if [ -z "$2" ]
then
  echo "$0: you need to pass a namespace name as a 2nd argument"
  exit 2
fi
if [ -z "$3" ]
then
  echo "$0: you need to pass a pod name as a 3rd argument"
  exit 3
fi
cmd="/bin/bash"
if [ ! -z "$4" ]
then
  cmd=$4
fi
change_namespace.sh $1 $2
if [ -z "$5" ]
then
  "${1}k.sh" exec -it "$3" -- $cmd
else
  "${1}k.sh" exec -it "$3" --container "$5" -- $cmd
fi
change_namespace.sh $1 default
