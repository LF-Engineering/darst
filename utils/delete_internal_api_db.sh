#!/bin/bash
for e in test prod
do
  #"${e}k.sh" -n devstats delete cj --all
  "${e}k.sh" delete ns devstats
  ../da-patroni/delete.sh "${e}"
  ./backups-page/delete.sh test
  ./mariadb/delete_backups.sh test
  ./openebs/delete.sh test
  "${e}eksctl.sh" delete nodegroup --name="dev-analytics-ng-devstats-${e}" --cluster "dev-analytics-kube-${e}"
done
