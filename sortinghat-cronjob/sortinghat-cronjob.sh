#!/bin/bash
# DRY=1 - will add --dry-run --debug flags
env="$1"
op="$2"
foundation="$3"
project="$4"
if [ -z "$env" ]
then
  echo "$0: you need to provide env as 1st arg: test, dev, stg, prod"
  exit 3
fi
if [ -z "$op" ]
then
  echo "$0: you need to operation as 2nd arg: install, upgrade"
  exit 4
fi
if [ -z "$foundation" ]
then
  echo "$0: you need to provide foundation as 3rd arg or use none for LF"
  exit 5
fi
if [ -z "$project" ]
then
  echo "$0: you need to provide project as 4th arg"
  exit 6
fi
if [ -z "$DOCKER_USER" ]
then
  echo "$0: you need to specify docker user via DOCKER_USER=..."
  exit 7
fi
if [ ! -z "$DRY" ]
then
  FLAGS="--dry-run --debug"
fi
. env.sh "$1" || exit 8
foundation_present=1
if [ "$foundation" = "none" ]
then
  foundation_present=0
fi
name="g-${foundation}-${project}"
if [ $foundation_present -eq 1 ]
then
  slug="${foundation}/${project}"
else
  name="g-lf-${project}"
  slug="${project}"
fi
name="g-${foundation}-${project}"

if [ $foundation_present -eq 1 ]
then
  slug="${foundation}/${project}"
else
  name="g-lf-${project}"
  slug="${project}"
fi
repository="${DOCKER_USER}/dev-analytics-grimoire-docker"
function finish {
  change_namespace.sh $env default
}
trap finish EXIT
api_url="dev-analytics-api-lb.dev-analytics-api-${env}"
shhost="`cat mariadb/secrets/HOST.secret`"
shdb="`cat mariadb/secrets/DB.secret`"
shuser="`cat mariadb/secrets/USER.secret`"
shpass="`cat mariadb/secrets/PASS.${1}.secret`"
if ( [ -z "$shhost" ] || [ -z "$shdb" ] || [ -z "$shuser" ] || [ -z "$shpass" ] )
then
  echo "$0: you need to provide value in ~/dev/darst/mariadb/secrets/HOST.secret, ~/dev/darst/mariadb/secrets/DB.secret, ~/dev/darst/mariadb/secrets/USER.secret and ~/dev/darst/mariadb/secrets/PASS.${1}.secret files"
  exit 12
fi
echo "Installing cronjob: $name $slug"
echo "API: $api_url"
change_namespace.sh $1 "$name"
if [ "$op" = "install" ]
then
  "${1}h.sh" install "${name}-id-maintenance" ./sortinghat-cronjob/sortinghat-cronjob-chart $FLAGS -n $name --set "image=$repository,db.name=$shdb,identity.db.name=$shdb,identity.db.host=$shhost,identity.db.user=$shuser,identity.db.password=$shpass"
elif [ "$op" = "upgrade" ]
then
  "${1}h.sh" upgrade "${name}-id-maintenance" ./sortinghat-cronjob/sortinghat-cronjob-chart $FLAGS -n $name --reuse-values --set "image=$repository,db.name=$shdb,identity.db.name=$shdb,identity.db.host=$shhost,identity.db.user=$shuser,identity.db.password=$shpass"
else
  echo "$0: unknown operation: $op"
  exit 9
fi
