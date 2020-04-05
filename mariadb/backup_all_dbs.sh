#!/bin/bash
if [ -z "$ONLY" ]
then
  #dbs=`mariadb -h$SH_HOST -u$SH_USER -p$SH_PASS -e "show databases" -s -N`
  dbs=`mariadb -h$SH_HOST -u$SH_USER -p$SH_PASS -e "select db from mysql.db where db not like 'test%'" -s -N`
else
  dbs="$ONLY"
fi
day=`date +%d`
for db in $dbs
do
  echo "db: $db"
  fn="${db}-${day}"
  ( mysqldump --single-transaction -h$SH_HOST -u$SH_USER -p$SH_PASS "$db" > /root/temp && bzip2 /root/temp && mv /root/temp.bz2 "/root/${fn}.sql.bz2" && ls -l "/root/${fn}.sql.bz2" ) || rm -f /root/temp /root/temp.bz2
done
echo 'OK'
