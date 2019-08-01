#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
k="${1}k.sh"
fn=/tmp/query.sql
function finish {
  rm -f "$fn" 2>/dev/null
  "$k" delete pod patroni-init
}
trap finish EXIT
cp dev_analytics/init.sql "$fn"
pass=`cat "~/dev/da-patroni/da-patroni/secrets/PG_PASS.$1.secret"`
if [ -z "$pass" ]
then
  echo "$0: you need to provide password value in ~/dev/da-patroni/da-patroni/secrets/PG_PASS.$1.secret"
  exit 1
fi
vim --not-a-term -c "%s/PWD/${pass}/g" -c 'wq!' "$fn"
"${1}k.sh" run --generator=run-pod/v1 --image=postgres patroni-init --env="PG_HOST=`cat ~/dev/da-patroni/da-patroni/secrets/PG_HOST.secret`" --env="PG_USER=`cat ~/dev/da-patroni/da-patroni/secrets/PG_ADMIN_USER.secret`" --env="PGPASSWORD=`cat ~/dev/da-patroni/da-patroni/secrets/PG_PASS.${1}.secret`" -- /bin/sleep 3600s
while [ ! "`${1}k.sh get po | grep patroni-init | awk '{ print $3 }'`" = "Running" ]
do
  echo "Waiting for pod to be running..."
  sleep 1
done
"${1}k.sh" cp dev_analytics/init_db.sh patroni-init:/usr/bin/init_db.sh
"${1}k.sh" cp "$fn" patroni-init:init.sql
"${1}k.sh" exec -it patroni-init -- /usr/bin/init_db.sh
