#!/bin/bash
# SHHOST=mysql.url - give MySQL hostname (if not set it will try to get that using testk.sh or prodk.sh if available)
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, prod"
  exit 1
fi
if [ -z "$SHHOST" ]
then
  has_k=1
  "${1}k.sh" 1>/dev/null 2>/dev/null || has_k=''
  if [ -z "$has_k" ]
  then
    echo "${1}k.sh is not available, please give MySQL host via SHHOST=..."
    exit 1
  fi
  SHHOST="`${1}k.sh get svc --all-namespaces | grep mariadb-service | awk '{ print $5 }'`"
  if [ -z "$SHHOST" ]
  then
    echo "Unable to find 'mariadb-service' external URL"
    exit 1
  fi
fi
mysql -h"${SHHOST}" -u"`cat mariadb/secrets/USER.secret`" -p"`cat mariadb/secrets/PASS.${1}.secret`" "`cat mariadb/secrets/DB.secret`"
