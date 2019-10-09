#!/bin/bash
# LIST=install - list install commands
# LIST=upgrade - list upgrade commands
# LIST=uninstall - list uninstall commands
# LIST=slg - list projects slugs
# LIST=anything_else - list projects
# SORT=col_name (for example 'sort_order'), default 'slug'
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
sortcol=slug
if [ ! -z "$SORT" ]
then
  sortcol=$SORT
fi
for proj in `"${1}k.sh" -n devstats exec devstats-postgres-0 -- psql "$db" -tAc "select slug from projects where project_type = 0 order by $sortcol"`
do
  IFS=\/ read -a ary <<<"$proj"
  foundation=${ary[0]}
  name=${ary[1]}
  if [ -z "$name" ]
  then
    name="$foundation"
    foundation="none"
  fi
  if ( [ "$LIST" = "install" ] || [ "$LIST" = "upgrade" ] )
  then
    if [ -z "$DOCKER_USER" ]
    then
      echo "DOCKER_USER=... ./grimoire/grimoire.sh $1 $LIST $foundation $name"
    else
      echo "DOCKER_USER=$DOCKER_USER ./grimoire/grimoire.sh $1 $LIST $foundation $name"
    fi
  elif [ "$LIST" = "uninstall" ]
  then
    echo "./grimoire/delete.sh $1 $foundation $name"
  elif [ "$LIST" = "slug" ]
  then
    if [ "$foundation" = "none" ]
    then
      echo $name
    else
      echo "$foundation/$name"
    fi
  else
    if [ "$foundation" = "none" ]
    then
      printf "Foundation: %-40s\tProject: %-40s\tSlug: %s\n" "$foundation" "$name" "$name"
    else
      printf "Foundation: %-40s\tProject: %-40s\tSlug: %s\n" "$foundation" "$name" "$foundation/$name"
    fi
  fi
done
