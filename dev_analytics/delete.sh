#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
k="${1}k.sh"
function finish {
  "$k" delete pod patroni-delete
}
trap finish EXIT
"${1}k.sh" run --generator=run-pod/v1 --image=postgres patroni-delete --env="PG_HOST=`cat ~/dev/da-patroni/da-patroni/secrets/PG_HOST.secret`" --env="PG_USER=`cat ~/dev/da-patroni/da-patroni/secrets/PG_ADMIN_USER.secret`" --env="PGPASSWORD=`cat ~/dev/da-patroni/da-patroni/secrets/PG_PASS.${1}.secret`" -- /bin/sleep 3600s
while [ ! "`${1}k.sh get po | grep patroni-delete | awk '{ print $3 }'`" = "Running" ]
do
  echo "Waiting for pod to be running..."
  sleep 1
done
"${1}k.sh" cp dev_analytics/delete_db.sh patroni-delete:/usr/bin/delete_db.sh
"${1}k.sh" exec -it patroni-delete -- /usr/bin/delete_db.sh "$1"
