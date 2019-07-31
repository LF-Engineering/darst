#!/bin/bash
dropdb -h$PG_HOST -U$PG_USER dev_analytics
createdb -h$PG_HOST -U$PG_USER dev_analytics
psql -h$PG_HOST -U$PG_USER dev_analytics < populate.sql
