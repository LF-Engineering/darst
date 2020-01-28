#!/bin/bash
if [ -z "$1" ]
then
  echo "$0: you need to specify env: test, prod"
  exit 1
fi
# PG_PASS is the password which will be set on the external DB (nternal DB uses secret for this)
# PGPASSWORD is the external RDS postgres/sa password which is needed for root access
if ( [ -z "$PG_HOST" ] || [ -z "$PG_USER" ] || [ -z "$PG_PASS" ] || [ -z "$PGPASSWORD" ] )
then
  echo "$0: you need to specify PG_HOST, PG_USER, PG_PASS, PGPASSWORD to run this script"
  exit 2
fi
fn=/tmp/query.sql
function finish {
  rm -f "$fn" 2>/dev/null
}
trap finish EXIT
cp dev_analytics/init_external.sql "$fn"
vim --not-a-term -c "%s/PWD/${PG_PASS}/g" -c 'wq!' "$fn"
dropdb -h$PG_HOST -U$PG_USER dev_analytics
psql -h$PG_HOST -U$PG_USER < "$fn"
psql -h$PG_HOST -U$PG_USER dev_analytics -c 'create extension if not exists pgcrypto schema public'
if [ "$1" = "test" ]
then
  dropdb -h$PG_HOST -U$PG_USER "dev_analytics_$1"
  psql -h$PG_HOST -U$PG_USER < "dev_analytics/init_$1.sql"
  psql -h$PG_HOST -U$PG_USER "dev_analytics_$1" -c 'create extension if not exists pgcrypto schema public'
fi
