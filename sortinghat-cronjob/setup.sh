#!/bin/bash
# DRY=1 - will add --dry-run --debug flags
env="$1"
op="$2"
if [ -z "$env" ]
then
  echo "$0: you need to provide env as 1st arg: test, dev, stg, prod"
  exit 1
fi
if [ -z "$op" ]
then
  echo "$0: you need to operation as 2nd arg: install, upgrade"
  exit 2
fi
if [ -z "$DOCKER_USER" ]
then
  echo "$0: you need to specify docker user via DOCKER_USER=..."
  exit 3
fi
if [ ! -z "$DRY" ]
then
  FLAGS="--dry-run --debug"
fi
. env.sh "$1" || exit 4
function finish {
  change_namespace.sh $env default
}
trap finish EXIT
repository="${DOCKER_USER}/dev-analytics-grimoire-docker"
api_url="dev-analytics-api-lb.dev-analytics-api-${env}"
shhost="`cat mariadb/secrets/HOST.secret`"
shdb="`cat mariadb/secrets/DB.secret`"
shuser="`cat mariadb/secrets/USER.secret`"
shpass="`cat mariadb/secrets/PASS.${1}.secret`"
if ( [ -z "$shhost" ] || [ -z "$shdb" ] || [ -z "$shuser" ] || [ -z "$shpass" ] )
then
  echo "$0: you need to provide value in ~/dev/darst/mariadb/secrets/HOST.secret, ~/dev/darst/mariadb/secrets/DB.secret, ~/dev/darst/mariadb/secrets/USER.secret and ~/dev/darst/mariadb/secrets/PASS.${1}.secret files"
  exit 5
fi
"${1}k.sh" apply -f sortinghat-cronjob/namespace.yaml
change_namespace.sh $1 id-maintenance
if [ "$op" = "install" ]
then
  "${1}h.sh" install id-maintenance ./sortinghat-cronjob/sortinghat-cronjob-chart $FLAGS -n id-maintenance --set "image=$repository,db.name=$shdb,identity.db.name=$shdb,identity.db.host=$shhost,identity.db.user=$shuser,identity.db.password=$shpass"
elif [ "$op" = "upgrade" ]
then
  "${1}h.sh" upgrade id-maintenance ./sortinghat-cronjob/sortinghat-cronjob-chart $FLAGS -n id-maintenance --reuse-values --set "image=$repository,db.name=$shdb,identity.db.name=$shdb,identity.db.host=$shhost,identity.db.user=$shuser,identity.db.password=$shpass"
else
  echo "$0: unknown operation: $op"
  exit 6
fi
