#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}k.sh" run --image=mariadb mariadb-test --env="SH_HOST=`cat mariadb/HOST.secret`" --env="SH_USER=`cat mariadb/USER.secret`" --env="SH_PASS=`cat mariadb/PASS.secret`" --env="SH_DB=`cat mariadb/DB.secret`" -- /bin/sleep 3600s
"${1}k.sh" -n mariadb delete deployment mariadb-test
