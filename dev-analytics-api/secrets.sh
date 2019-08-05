#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
. env.sh "$1" || exit 1
# FIXME: why do we need seed_env?
seed_env_short=dev
seed_env_long=develop
env_short=$1
function finish {
  change_namespace.sh $env_short default
}
trap finish EXIT
cd ~/dev/dev-analytics-api || exit 1
"${1}k.sh" create -f "./.circleci/deployments/$API_DIR/namespace.json"
change_namespace.sh $1 "dev-analytics-api-$ENV_NS"
export PUBLIC_KEY_VALUE=$(cat .circleci/deployments/$API_DIR/secrets.ejson | jq -r '._public_key')
# FIXME: here seeding private key from 'develop' env, we need to be able to get that value without needing any other envs setup.
export PRIVATE_KEY_VALUE=$(${seed_env_short}k.sh get secret ejson-keys --namespace=dev-analytics-api-$seed_env_long -o json | jq -rc '.data.'$PUBLIC_KEY_VALUE | base64 --decode)
"${1}k.sh" create secret generic ejson-keys --from-literal=$PUBLIC_KEY_VALUE=$PRIVATE_KEY_VALUE --namespace=dev-analytics-api-$ENV_NS
cd .circleci/deployments || exit 2
./update-secret.sh $ENV_NS DATABASE_HOST "`cat ~/dev/da-patroni/da-patroni/secrets/PG_HOST.secret`" > /dev/null
./update-secret.sh $ENV_NS DATABASE_PASSWORD "`cat ~/dev/da-patroni/da-patroni/secrets/PG_PASS.$1.secret`" > /dev/null
./update-secret.sh $ENV_NS DATABASE_USERNAME "`cat ~/dev/da-patroni/da-patroni/secrets/PG_USER.secret`" > /dev/null
./update-secret.sh $ENV_NS RAILS_ENV $ENV_NS > /dev/null
# ./update-secret.sh $ENV_NS REDIS_URL "`cat ~/dev/darst/redis/secrets/URL.secret`" > /dev/null
# ./update-secret.sh $ENV_NS REDIS_URL_ROOT "redis://redis.redis" > /dev/null
./update-secret.sh $ENV_NS REDIS_URL "redis-master.redis" > /dev/null
./update-secret.sh $ENV_NS REDIS_URL_ROOT "redis-master.redis" > /dev/null
./update-secret.sh $ENV_NS REDIS_PASSWORD "`cat ~/dev/darst/redis/secrets/PASS.${1}.secret`" > /dev/null
./update-secret.sh $ENV_NS DEVSTATS_DB_HOST "`cat ~/dev/da-patroni/da-patroni/secrets/PG_HOST.secret`" > /dev/null
./update-secret.sh $ENV_NS SORTINGHAT_HOST "`cat ~/dev/darst/mariadb/secrets/HOST.secret`" > /dev/null
# FIXME: we should have those keys
./update-secret.sh $ENV_NS SORTINGHAT_USER "`cat ~/dev/darst/mariadb/secrets/USER.secret`" > /dev/null
./update-secret.sh $ENV_NS SORTINGHAT_PASSWORD "`cat ~/dev/darst/mariadb/secrets/PASS.$1.secret`" > /dev/null
# FIXME: how about those keys?
# ./update-secret.sh $ENV_NS RAILS_MASTER_KEY '?' (its not needed probably), how about SalesForce keys?
./update-secret.sh $ENV_NS
rm -rf "$API_DIR/temp-key/" 2>/dev/null
git status
