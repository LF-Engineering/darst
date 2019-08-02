#!/bin/bash
dropdb -h$PG_HOST -U$PG_USER dev_analytics
psql -h$PG_HOST -U$PG_USER < init.sql
if [ "$1" = "test" ]
then
  dropdb -h$PG_HOST -U$PG_USER "dev_analytics_$1"
  psql -h$PG_HOST -U$PG_USER < "init_$1.sql"
fi
