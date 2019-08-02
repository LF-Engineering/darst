#!/bin/bash
dropdb -h$PG_HOST -U$PG_USER dev_analytics
createdb -h$PG_HOST -U$PG_USER dev_analytics
psql -h$PG_HOST -U$PG_USER dev_analytics < populate.sql
if [ "$1" = "test" ]
then
  dropdb -h$PG_HOST -U$PG_USER "dev_analytics_$1"
  createdb -h$PG_HOST -U$PG_USER "dev_analytics_$1"
  psql -h$PG_HOST -U$PG_USER "dev_analytics_$1" < populate.sql
fi
