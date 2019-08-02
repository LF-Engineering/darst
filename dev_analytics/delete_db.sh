#!/bin/bash
psql -h$PG_HOST -U$PG_USER postgres -c "select pg_terminate_backend(pid) from pg_stat_activity where datname = 'dev_analytics'"
dropdb -h$PG_HOST -U$PG_USER dev_analytics
if [ "$1" = "test" ]
then
  psql -h$PG_HOST -U$PG_USER postgres -c "select pg_terminate_backend(pid) from pg_stat_activity where datname = 'dev_analytics_$1'"
  dropdb -h$PG_HOST -U$PG_USER "dev_analytics_$1"
fi
