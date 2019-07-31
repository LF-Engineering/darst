#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
change_namespace.sh $1 devstats > /dev/null
echo "http://`${1}k.sh -n devstats get svc backups-page-service  | grep backups-page-service | awk '{ print $4 }'`:80"
change_namespace.sh $1 mariadb > /dev/null
echo "http://`${1}k.sh -n mariadb get svc backups-page-service  | grep backups-page-service | awk '{ print $4 }'`:80"
change_namespace.sh $1 default > /dev/null
