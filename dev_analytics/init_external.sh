#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, prod"
  exit 1
fi
if ( [ -z "$PG_HOST" ] || [ -z "$PG_USER" ] || [ -z "$PGPASSWORD" ] )
then
  echo "$0: you need to specify PG_HOST, PG_USER, PGPASSWORD to run this script"
  exit 2
fi
fn=/tmp/query.sql
function finish {
  rm -f "$fn" 2>/dev/null
}
trap finish EXIT
cp dev_analytics/init.sql "$fn"
pass="`cat ~/dev/da-patroni/da-patroni/secrets/PG_PASS.$1.secret`"
if [ -z "$pass" ]
then
  echo "$0: you need to provide password value in ~/dev/da-patroni/da-patroni/secrets/PG_PASS.$1.secret"
  exit 1
fi
vim --not-a-term -c "%s/PWD/${pass}/g" -c 'wq!' "$fn"
dropdb -h$PG_HOST -U$PG_USER dev_analytics
psql -h$PG_HOST -U$PG_USER < "$fn"
psql -h$PG_HOST -U$PG_USER dev_analytics -c 'create extension if not exists pgcrypto schema public'
if [ "$1" = "test" ]
then
  dropdb -h$PG_HOST -U$PG_USER "dev_analytics_$1"
  psql -h$PG_HOST -U$PG_USER < "init_$1.sql"
  psql -h$PG_HOST -U$PG_USER "dev_analytics_$1" -c 'create extension if not exists pgcrypto schema public'
fi
