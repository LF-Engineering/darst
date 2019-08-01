#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
env=$1
if [ "$env" = "stg" ]
then
  env=staging
fi
if [ "$env" = "dev" ]
then
  env=develop
fi
# FIXME: why do we need seed_env?
seed_env_short=dev
seed_env_long=develop
env_short=$1
function finish {
  change_namespace.sh $env_short default
}
trap finish EXIT
cd ~/dev/dev-analytics-api || exit 1
"${1}k.sh" create -f "./.circleci/deployments/$env/namespace.json"
change_namespace.sh $1 "dev-analytics-api-$env"
export PUBLIC_KEY_VALUE=$(cat .circleci/deployments/$env/secrets.ejson | jq -r '._public_key')
# FIXME: here seeding private key from 'develop' env, we need to be able to get that value without needing any other envs setup.
export PRIVATE_KEY_VALUE=$(${seed_env_short}k.sh get secret ejson-keys --namespace=dev-analytics-api-$seed_env_long -o json | jq -rc '.data.'$PUBLIC_KEY_VALUE | base64 --decode)
"${1}k.sh" create secret generic ejson-keys --from-literal=$PUBLIC_KEY_VALUE=$PRIVATE_KEY_VALUE --namespace=dev-analytics-api-$env
export KUBECONFIG="/root/.kube/kubeconfig_$1"
export AWS_PROFILE="lfproduct-$1"
cd .circleci/deployments || exit 2
./update-secret.sh $env DATABASE_HOST "`cat ~/dev/da-patroni/da-patroni/secrets/PG_HOST.secret`"
./update-secret.sh $env DATABASE_PASSWORD "`cat ~/dev/da-patroni/da-patroni/secrets/PG_PASS.$1.secret`"
./update-secret.sh $env DATABASE_USERNAME "`cat ~/dev/da-patroni/da-patroni/secrets/PG_USER.secret`"
./update-secret.sh $env RAILS_ENV $env
./update-secret.sh $env REDIS_URL_ROOT "redis://redis.redis"
./update-secret.sh $env REDIS_URL "`cat ~/dev/darst/redis/secrets/URL.secret`"
./update-secret.sh $env DEVSTATS_DB_HOST "`cat ~/dev/da-patroni/da-patroni/secrets/PG_HOST.secret`"
./update-secret.sh $env SORTINGHAT_HOST "`cat ~/dev/darst/mariadb/secrets/HOST.secret`"
# FIXME: we should have those keys
./update-secret.sh $env SORTINGHAT_USER "`cat ~/dev/darst/mariadb/secrets/USER.secret`"
./update-secret.sh $env SORTINGHAT_PASSWORD "`cat ~/dev/darst/mariadb/secrets/PASS.$1.secret`"
# FIXME: how about those keys?
# ./update-secret.sh $env RAILS_MASTER_KEY '?' (its not needed probably), how about SalesForce keys?
./update-secret.sh $env
