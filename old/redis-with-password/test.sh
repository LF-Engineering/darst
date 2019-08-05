#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}k.sh" run --generator=run-pod/v1 redis-test -i --tty --restart=Never --rm --image="bitnami/redis" --env="REDISCLI_AUTH=`cat redis/secrets/PASS.${1}.secret`" -- redis-cli -h redis-master.redis ping
#"${1}k.sh" delete pod curl-test-es
