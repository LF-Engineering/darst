#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}k.sh" run --generator=run-pod/v1 redis-test -i --tty --restart=Never --rm --image="bitnami/redis" -- redis-cli -h redis-master.redis config get databases
