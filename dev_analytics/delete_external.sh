#!/bin/bash
if [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if ( [ -z "$PG_HOST" ] || [ -z "$PG_USER" ] || [ -z "$PGPASSWORD" ] )
then
  echo "$0: you need to specify PG_HOST, PG_USER, PGPASSWORD to run this script"
  exit 2
fi
psql -h$PG_HOST -U$PG_USER postgres -c "select pg_terminate_backend(pid) from pg_stat_activity where datname = 'dev_analytics'"
dropdb -h$PG_HOST -U$PG_USER dev_analytics
if [ "$1" = "test" ]
then
  psql -h$PG_HOST -U$PG_USER postgres -c "select pg_terminate_backend(pid) from pg_stat_activity where datname = 'dev_analytics_$1'"
  dropdb -h$PG_HOST -U$PG_USER "dev_analytics_$1"
fi
psql -h$PG_HOST -U$PG_USER < ./dev_analytics/delete.sql
