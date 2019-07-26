#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
k="${1}k.sh"
function finish {
  "$k" delete pod mariadb-structure
}
trap finish EXIT
"${1}k.sh" run --generator=run-pod/v1 --image=mariadb mariadb-structure --env="SH_HOST=`cat mariadb/HOST.secret`" --env="SH_USER=`cat mariadb/USER.secret`" --env="SH_PASS=`cat mariadb/PASS.secret`" --env="SH_DB=`cat mariadb/DB.secret`" -- /bin/sleep 3600s
while [ ! "`${1}k.sh get po | grep mariadb-structure | awk '{ print $3 }'`" = "Running" ]
do
  echo "Waiting for pod to be running..."
  sleep 1
done
"${1}k.sh" cp ../merge-sh-dbs/dump_struct.sql mariadb-structure:structure.sql
"${1}k.sh" cp mariadb/structure_db.sh mariadb-structure:/usr/bin/structure_db.sh
"${1}k.sh" exec -it mariadb-structure -- /usr/bin/structure_db.sh
