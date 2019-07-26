#!/bin/bash
# DOCKER_USER=lukaszgryglicki SKIP_PUSH=1 SKIP_RM=1
if [ -z "${DOCKER_USER}" ]
then
  echo "$0: you need to set docker user via DOCKER_USER=username"
  exit 1
fi

docker build -f ./mariadb/Dockerfile.mariadb.backups -t "${DOCKER_USER}/mariadb-backups" . || exit 2

if [ ! -z "$SKIP_PUSH" ]
then
  docker push "${DOCKER_USER}/mariadb-backups" || exit 2
fi

if [ ! -z "$SKIP_RM" ]
then
  docker image rm -f "${DOCKER_USER}/mariadb-backups"
fi
