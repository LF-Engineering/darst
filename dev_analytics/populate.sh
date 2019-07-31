#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if [ ! -f "dev_analytics/dev_analytics.sql.secret" ]
then
  echo "$0: you need to provide 'dev_analytics/dev_analytics.sql.secret' file to run this script"
  exit 2
fi
k="${1}k.sh"
function finish {
  "$k" delete pod patroni-populate
}
trap finish EXIT
"${1}k.sh" run --generator=run-pod/v1 --image=postgres patroni-populate --env="PG_HOST=`cat ~/dev/da-patroni/da-patroni/secrets/PG_HOST.secret`" --env="PG_USER=`cat ~/dev/da-patroni/da-patroni/secrets/PG_ADMIN_USER.secret`" --env="PGPASSWORD=`cat ~/dev/da-patroni/da-patroni/secrets/PG_PASS.${1}.secret`" -- /bin/sleep 3600s
while [ ! "`${1}k.sh get po | grep patroni-populate | awk '{ print $3 }'`" = "Running" ]
do
  echo "Waiting for pod to be running..."
  sleep 1
done
"${1}k.sh" cp dev_analytics/populate_db.sh patroni-populate:/usr/bin/populate_db.sh
"${1}k.sh" cp dev_analytics/dev_analytics.sql.secret patroni-populate:populate.sql
"${1}k.sh" exec -it patroni-populate -- /usr/bin/populate_db.sh
