#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
k="${1}k.sh"
function finish {
  "$k" delete pod mariadb-test
}
trap finish EXIT
"${1}k.sh" run --generator=run-pod/v1 --image=mariadb mariadb-test --env="SH_HOST=`cat mariadb/secrets/HOST.secret`" --env="SH_USER=`cat mariadb/secrets/USER.secret`" --env="SH_PASS=`cat mariadb/secrets/PASS.${1}.secret`" --env="SH_DB=`cat mariadb/secrets/DB.secret`" -- /bin/sleep 36000s
while [ ! "`${1}k.sh get po | grep mariadb-test | awk '{ print $3 }'`" = "Running" ]
do
  echo "Waiting for pod to be running..."
  sleep 1
done
"${1}k.sh" exec -it mariadb-test -- /opt/bitnami/mariadb/bin/mysql -h$SH_HOST -u$SH_USER -p$SH_PASS $SH_DB
