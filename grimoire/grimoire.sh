#!/bin/bash
# DRY=1 - will add --dry-run --debug flags
# WORKERS=n - override default number of arthurw workers which is 1
# NODE=grimoire - use other node selector, set NODE='-' to skip node selector
# DEBUG=1 - will set manualDebug=1 mode, which creates deployment but all services are '/bin/sleep infinity'
# NS=name - overwrite namespace name generation
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
  FLAGS="$FALGS --dry-run --debug"
fi
if [ ! -z "$DEBUG" ]
then
  FLAGS="$FLAGS --set manualDebug=1"
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
if [ ! -z "$NS" ]
then
  name=$NS
fi
workers=1
if [ ! -z "$WORKERS" ]
then
  workers="$WORKERS"
fi
nodeSelector=grimoire
useNodeSelector=1
if [ ! -z "$NODE" ]
then
  if [ "$NODE" = "-" ]
  then
    useNodeSelector=''
  else
    nodeSelector="$NODE"
  fi
fi
identity_repository="${DOCKER_USER}/dev-analytics-sortinghat-api"
repository="${DOCKER_USER}/dev-analytics-grimoire-docker"
fn=/tmp/ns.yaml
custom=/tmp/custom.yaml
function finish {
  rm -f "$custom" "$fn"
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
cp grimoire/namespace.yaml "$fn"
cp grimoire/custom.yaml "$custom"
vim --not-a-term -c "%s/NAME/${name}/g" -c 'wq!' "$fn"
vim --not-a-term -c "%s/WORKERS/${workers}/g" -c 'wq!' "$custom"
"${1}k.sh" apply -f "$fn"
change_namespace.sh $1 "$name"
if [ "$op" = "install" ]
then
  "${1}h.sh" install "$name" ./grimoire/grimoire-chart $FLAGS -n $name -f "$custom" --set "api.url=$api_url,projectSlug=$slug,image=$repository,identity.image=$identity_repository,identity.db.name=$shdb,identity.db.host=$shhost,identity.db.user=$shuser,identity.db.password=$shpass,web_concurency=$wcon,flask_env=$fenv,flask_debug=$fdbg,log_level=$llev,useNodeSelector=${useNodeSelector},nodeSelector.lfda=${nodeSelector}"
elif [ "$op" = "upgrade" ]
then
  "${1}h.sh" upgrade "$name" ./grimoire/grimoire-chart $FLAGS -n $name --reuse-values -f "$custom" --set "api.url=$api_url,projectSlug=$slug,image=$repository,identity.image=$identity_repository,identity.db.name=$shdb,identity.db.host=$shhost,identity.db.user=$shuser,identity.db.password=$shpass,web_concurency=$wcon,flask_env=$fenv,flask_debug=$fdbg,log_level=$llev,useNodeSelector=${useNodeSelector},nodeSelector.lfda=${nodeSelector}"
else
  echo "$0: unknown operation: $op"
  exit 9
fi
