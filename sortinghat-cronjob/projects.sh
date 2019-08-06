#!/bin/bash
# LIST=install - list install commands
# LIST=upgrade - list upgrade commands
# LIST=uninstall - list uninstall commands
# LIST=anything_else - list projects
if [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
db=dev_analytics
if [ "$1" = "test" ]
then
  db=dev_analytics_test
fi
for proj in `"${1}k.sh" -n devstats exec devstats-postgres-0 -- psql "$db" -tAc 'select slug from projects order by slug'`
do
  IFS=\/ read -a ary <<<"$proj"
  name=${ary[0]}
  foundation=${ary[1]}
  if [ -z "$foundation" ]
  then
    foundation="none"
  fi
  if ( [ "$LIST" = "install" ] || [ "$LIST" = "upgrade" ] )
  then
    if [ -z "$DOCKER_USER" ]
    then
      echo "DOCKER_USER=... ./sortinghat-cronjob/sortinghat-cronjob.sh $1 $LIST $foundation $name"
    else
      echo "DOCKER_USER=$DOCKER_USER ./sortinghat-cronjob/sortinghat-cronjob.sh $1 $LIST $foundation $name"
    fi
  elif [ "$LIST" = "uninstall" ]
  then
    echo "./sortinghat-cronjob/delete.sh $1 $foundation $name"
  else
    printf "Foundation: %-30s\tProject: %s\n" "$foundation" "$name"
  fi
done
