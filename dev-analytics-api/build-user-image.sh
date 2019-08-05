#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if [ -z "$DOCKER_USER" ]
then
  echo "$0: you need to specify docker user via DOCKER_USER=..."
  exit 2
fi
cd ~/dev/dev-analytics-api || exit 3
docker build -f Dockerfile -t "${DOCKER_USER}/dev-analytics-api" . || exit 4
docker push "${DOCKER_USER}/dev-analytics-api" || exit 5
docker system prune -f
