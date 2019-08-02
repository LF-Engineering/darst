#!/bin/bash
if [ -z "$1" ]
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
dd=/tmp/k8sdeploy
function finish {
  rm -rf "$dd"
}
trap finish EXIT
rm -rf "$dd"
mkdir "$dd"
cp ~/dev/dev-analytics-api/.circleci/deployments/$API_DIR/* "$dd" || exit 3
vim --not-a-term -c "%s/image: .*/image: $DOCKER_USER\/dev-analytics-api/g" -c 'wq!' "${dd}/api.deployment.yml.erb"
vim --not-a-term -c "%s/image: .*/image: $DOCKER_USER\/dev-analytics-api/g" -c '%s/"bundle", "exec", "rails", "db:migrate"/"bundle", "exec", "rails", "db:migrate", "db:seed"/g' -c '%s/120/1800/g' -c 'wq!' "${dd}/migrate.yml.erb"
context="`${1}k.sh config current-context`"
TASK_ID=`date +'%s%N'` kubernetes-deploy "dev-analytics-api-$ENV_NS" "$context" --template-dir="$dd"
