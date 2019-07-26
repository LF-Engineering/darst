#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
k="${1}k.sh"
function finish {
  #"$k" delete pod mariadb-test
  ls
}
trap finish EXIT
"${1}k.sh" run --generator=run-pod/v1 --image=mariadb mariadb-test --env="SH_HOST=`cat mariadb/HOST.secret`" --env="SH_USER=`cat mariadb/USER.secret`" --env="SH_PASS=`cat mariadb/PASS.secret`" --env="SH_DB=`cat mariadb/DB.secret`" -- /bin/sleep 3600s
while [ ! "`${1}k.sh get po | grep mariadb-test | awk '{ print $3 }'`" = "Running" ]
do
  echo "Waiting for pod to be running..."
  sleep 1
done
"${1}k.sh" cp mariadb/test_db.sh mariadb-test:/usr/bin/test_db.sh
