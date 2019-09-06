#!/bin/bash
# NO_DNS=1 - do not create external API server endpoint
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
  #cat "${dd}/api.deployment.yml.erb"
  rm -rf "$dd"
}
trap finish EXIT
rm -rf "$dd"
mkdir "$dd"
api_url="api\.${TF_DIR}\.lfanalytics\.io"
cert=`cat "dev-analytics-api/secrets/ssl-cert.$1.secret"`
cert="${cert//\//\\\/}"
cert="${cert//\./\\\.}"
if [ -z "$cert" ]
then
  echo "$0: you need to provide values in dev-analytics-api/secrets/ssl-cert.$1.secret"
  exit 2
fi
cp ~/dev/dev-analytics-api/.circleci/deployments/$API_DIR/* "$dd" || exit 3
vim --not-a-term -c "%s/image: .*/image: $DOCKER_USER\/dev-analytics-api/g" -c 'wq!' "${dd}/api.deployment.yml.erb"
vim --not-a-term -c "%s/external-dns\.alpha\.kubernetes\.io\/hostname: .*/external-dns\.alpha\.kubernetes\.io\/hostname: ${api_url}/g" -c "%s/service\.beta\.kubernetes\.io\/aws-load-balancer-ssl-cert: .*/service\.beta\.kubernetes\.io\/aws-load-balancer-ssl-cert: ${cert}/g" -c 'wq!' "${dd}/api.deployment.yml.erb"
vim --not-a-term -c "%s/image: .*/image: $DOCKER_USER\/dev-analytics-api/g" -c '%s/"bundle", "exec", "rails", "db:migrate"/"\/bin\/sh", "-c", "bundle exec rails db:reset; bundle exec rails db:migrate"/g' -c 'wq!' "${dd}/migrate.yml.erb"
if [ ! -z "$NO_DNS" ]
then
  vim --not-a-term -c "%s/external-dns\..*//g" -c "%s/service.beta.kubernetes.io\/aws-load-balancer.*//g" -c 'wq!' "${dd}/api.deployment.yml.erb"
fi
cat dev-analytics-api/sortinghat.partial >> "${dd}/api.deployment.yml.erb"
cat dev-analytics-api/env.partial >> "${dd}/api.deployment.yml.erb"
if [ "$1" = "test" ]
then
  cat dev-analytics-api/sortinghat.partial.test >> "${dd}/api.deployment.yml.erb"
fi
if [ "$1" = "prod" ]
then
  cat dev-analytics-api/env.partial.prod >> "${dd}/migrate.yml.erb"
fi
context="`${1}k.sh config current-context`"
TASK_ID=`date +'%s%N'` kubernetes-deploy "dev-analytics-api-$ENV_NS" "$context" --template-dir="$dd"
