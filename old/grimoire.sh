#!/bin/bash
# DRY=1 - will add --dry-run --debug flags
# NO_API_DNS=1 - use internal kubernetes service for API calls (when no external DNS API is available).
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
identity_repository="${DOCKER_USER}/dev-analytics-sortinghat-api"
repository="${DOCKER_USER}/dev-analytics-grimoire-docker"
fn=/tmp/ns.yaml
function finish {
  rm -f "$fn"
  change_namespace.sh $env default
}
trap finish EXIT
api_url="https://`cat grimoire/secrets/api-url.${1}.secret`"
if [ -z "$api_url" ]
then
  echo "$0: you need to provide API URL in grimoire/secrets/api-url.${1}.secret"
  exit 10
fi
if [ -z "$NO_API_DNS" ]
then
  identity_database="`curl -s ${api_url}/api/internal/grimoire/configuration/${slug}/environment | jq .SORTINGHAT_DATABASE`"
else
  "${1}k.sh" delete po api-temp 1>/dev/null 2>/dev/null
  api_url="dev-analytics-api-lb.dev-analytics-api-${env}"
  identity_database=`"${1}k.sh" run --generator=run-pod/v1 api-temp -i --tty --restart=Never --rm --image="radial/busyboxplus:curl" --quiet --command "/usr/bin/curl" -- "${api_url}/api/internal/grimoire/configuration/${slug}/environment" | jq .SORTINGHAT_DATABASE`
fi
if [ -z "$identity_database" ]
then
  echo "$0: failed to get data from ${api_url}"
  exit 11
fi
shhost="`cat mariadb/secrets/HOST.secret`"
shuser="`cat mariadb/secrets/USER.secret`"
shpass="`cat mariadb/secrets/PASS.${1}.secret`"
if ( [ -z "$shhost" ] || [ -z "$shuser" ] || [ -z "$shpass" ] )
then
  echo "$0: you need to provide value in ~/dev/darst/mariadb/secrets/HOST.secret, ~/dev/darst/mariadb/secrets/USER.secret and ~/dev/darst/mariadb/secrets/PASS.${1}.secret files"
  exit 12
fi
wcon=`cat "dev-analytics-sortinghat-api/parameters/WEB_CONCURENCY.$1.parameter"`
fenv=`cat "dev-analytics-sortinghat-api/parameters/FLASK_ENV.$1.parameter"`
fdbg=`cat "dev-analytics-sortinghat-api/parameters/FLASK_DEBUG.$1.parameter"`
llev=`cat "dev-analytics-sortinghat-api/parameters/LOG_LEVEL.$1.parameter"`
if ( [ -z "$wcon" ] || [ -z "$fenv" ] || [ -z "$fdbg" ] || [ -z "$llev" ] )
then
  echo "$0: you need to provide values in dev-analytics-sortinghat-api/parameters/WEB_CONCURENCY.$1.parameter, dev-analytics-sortinghat-api/parameters/FLASK_ENV.$1.parameter, dev-analytics-sortinghat-api/parameters/FLASK_DEBUG.$1.parameter and dev-analytics-sortinghat-api/parameters/LOG_LEVEL.$1.parameter files"
  exit 13
fi
echo "Installing: $name $slug"
echo "API: $api_url"
echo "ID DB: $identity_database"
cp grimoire/namespace.yaml "$fn"
vim --not-a-term -c "%s/NAME/${name}/g" -c 'wq!' "$fn"
"${1}k.sh" apply -f "$fn"
change_namespace.sh $1 "$name"
if [ "$op" = "install" ]
then
  "${1}h.sh" install "$name" ./grimoire/grimoire-chart $FLAGS -n $name --set "api.url=$api_url,projectSlug=$slug,image=$repository,identity.image=$identity_repository,identity.db.name=$identity_database,identity.db.host=$shhost,identity.db.user=$shuser,identity.db.password=$shpass,web_concurency=$wcon,flask_env=$fenv,flask_debug=$fdbg,log_level=$llev"
elif [ "$op" = "upgrade" ]
then
  "${1}h.sh" upgrade "$name" ./grimoire/grimoire-chart $FLAGS -n $name --reuse-values --set "api.url=$api_url,projectSlug=$slug,image=$repository,identity.image=$identity_repository,identity.db.name=$identity_database,identity.db.host=$shhost,identity.db.user=$shuser,identity.db.password=$shpass,web_concurency=$wcon,flask_env=$fenv,flask_debug=$fdbg,log_level=$llev"
else
  echo "$0: unknown operation: $op"
  exit 9
fi
