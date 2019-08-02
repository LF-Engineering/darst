#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if [ -z "$DOCKER_USER" ]
then
  echo "$0: you need to specify docker user via DOCKER_USER=..."
  exit 1
fi
. env.sh "$1" || exit 1
ns=/tmp/ns.yaml
fn=/tmp/apply.yaml
function finish {
  #rm -f "$ns" "$fn" 2>/dev/null
  cat "$ns" "$fn"
}
trap finish EXIT
cp dev-analytics-sortinghat-api/namespace.yaml "$ns"
cp dev-analytics-sortinghat-api/deployment.yaml "$fn"
host=`cat "mariadb/secrets/HOST.secret"`
user=`cat "mariadb/secrets/USER.secret"`
pass=`cat "mariadb/secrets/PASS.$1.secret"`
db=`cat "mariadb/secrets/DB.secret"`
if ( [ -z "$host" ] || [ -z "$user" ] || [ -z "$pass" ] || [ -z "$db" ] )
then
  echo "$0: you need to provide values in mariadb/secrets/HOST.secret, mariadb/secrets/USER.secret, mariadb/secrets/PASS.$1.secret and mariadb/secrets/DB.secret files"
  exit 2
fi
wcon=`cat "dev-analytics-sortinghat-api/parameters/WEB_CONCURENCY.$1.parameter"`
fenv=`cat "dev-analytics-sortinghat-api/parameters/FLASK_ENV.$1.parameter"`
fdbg=`cat "dev-analytics-sortinghat-api/parameters/FLASK_DEBUG.$1.parameter"`
llev=`cat "dev-analytics-sortinghat-api/parameters/LOG_LEVEL.$1.parameter"`
if ( [ -z "$wcon" ] || [ -z "$fenv" ] || [ -z "$fdbg" ] || [ -z "$llev" ] )
then
  echo "$0: you need to provide values in dev-analytics-sortinghat-api/parameters/WEB_CONCURENCY.$1.parameter, dev-analytics-sortinghat-api/parameters/FLASK_ENV.$1.parameter, dev-analytics-sortinghat-api/parameters/FLASK_DEBUG.$1.parameter and dev-analytics-sortinghat-api/parameters/LOG_LEVEL.$1.parameter files"
  exit 3
fi
vim --not-a-term -c "%s/{SH_HOST}/${host}/g" -c "%s/{SH_USER}/${user}/g" -c "%s/{SH_PASS}/${pass}/g" -c "%s/{SH_DB}/${db}/g" -c "%s/{WEB_CONCURENCY}/${wcon}/g" -c "%s/{FLASK_ENV}/${fenv}/g" -c "%s/{FLASK_DEBUG}/${fdbg}/g" -c "%s/{LOG_LEVEL}/${llev}/g" -c "%s/IMAGE/${DOCKER_USER}\/dev-analytics-sortinghat-api/g" -c 'wq!' "$fn"
vim --not-a-term -c "%s/ENV/${ENV_NS}/g" -c 'wq!' "$ns"
"${1}k.sh" create -f "$ns"
change_namespace.sh $1 sortinghat-api
"${1}k.sh" -n sortinghat-api create -f "$fn"
change_namespace.sh $1 default
