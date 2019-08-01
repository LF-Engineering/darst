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
./dev-analytics-api/secrets.sh "$1"
./dev-analytics-api/kubernetes-deploy.sh "$1"
