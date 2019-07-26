#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
k="${1}k.sh"
function finish {
  "$k" delete pod mariadb-populate
}
trap finish EXIT
"${1}k.sh" run --generator=run-pod/v1 --image=mariadb mariadb-populate --env="SH_HOST=`cat mariadb/HOST.secret`" --env="SH_USER=`cat mariadb/USER.secret`" --env="SH_PASS=`cat mariadb/PASS.secret`" --env="SH_DB=`cat mariadb/DB.secret`" -- /bin/sleep 3600s
while [ ! "`${1}k.sh get po | grep mariadb-populate | awk '{ print $3 }'`" = "Running" ]
do
  echo "Waiting for pod to be running..."
  sleep 1
done
"${1}k.sh" cp ../merge-sh-dbs/merged.sql mariadb-populate:populate.sql
"${1}k.sh" cp mariadb/populate_db.sh mariadb-populate:/usr/bin/populate_db.sh
"${1}k.sh" exec -it mariadb-populate -- /usr/bin/populate_db.sh
