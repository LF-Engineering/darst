#!/bin/bash
# DRY=1 - will add --dry-run --debug flags
# NO_API_DNS=1 - use internal kubernetes service for API calls (when no external DNS API is available).
env="$1"
op="$2"
foundation="$3"
project="$4"
if [ -z "$env" ]
then
  echo "$0: you need to provide env as 1st arg: test, dev, stg, prod"
  exit 3
fi
if [ -z "$op" ]
then
  echo "$0: you need to operation as 2nd arg: install, upgrade"
  exit 4
fi
if [ -z "$foundation" ]
then
  echo "$0: you need to provide foundation as 3rd arg or use none for LF"
  exit 5
fi
if [ -z "$project" ]
then
  echo "$0: you need to provide project as 4th arg"
  exit 6
fi
if [ -z "$DOCKER_USER" ]
then
  echo "$0: you need to specify docker user via DOCKER_USER=..."
  exit 7
fi
if [ ! -z "$DRY" ]
then
  FLAGS="--dry-run --debug"
fi
. env.sh "$1" || exit 8
if [ "$foundation" = "none" ]
then
  foundation_present=0
fi
name="g-${foundation}-${project}"
if [ $foundation_present -eq 1 ]
then
  slug="${foundation}/${project}"
else
  name="g-lf-${project}"
  slug="${project}"
fi
name="g-${foundation}-${project}"

if [ $foundation_present -eq 1 ]
then
  slug="${foundation}/${project}"
else
  name="g-lf-${project}"
  slug="${project}"
fi
identity_repository="${DOCKER_USER}/dev-analytics-sortinghat-api"
repository="${DOCKER_USER}/dev-analytics-grimoire-docker"
api_url="https://`cat grimoire/secrets/api-url.${1}.secret`"
if [ -z "$api_url" ]
then
  echo "$0: you need to provide API URL in grimoire/secrets/api-url.${1}.secret"
  exit 10
fi
if [ -z "$NO_API_DNS" ]
then
  identity_database="$(curl -s ${api_url}/api/internal/grimoire/configuration/${slug}/environment |jq .SORTINGHAT_DATABASE)"
else
  "${1}k.sh" delete po api-temp 1>/dev/null 2>/dev/null
  api_url="dev-analytics-api-lb.dev-analytics-api-${env}"
  identity_database=`"${1}k.sh" run --generator=run-pod/v1 api-temp -i --tty --restart=Never --rm --image="radial/busyboxplus:curl" --quiet --command "/usr/bin/curl" -- "${api_url}/api/internal/grimoire/configuration/${slug}/environment" | jq .SORTINGHAT_DATABASE`
fi
if [ -z "$identity_database" ]
then
  echo "$0: failed to get data from ${api_url}"
  exit 11
fi

echo "Installing: $name $slug"
echo "API: $api_url"
echo "ID DB: $identity_database"

read -p "Continue (y/n) " choice

case "$choice" in 
  y|Y ) echo "Upgrading";;
  n|N ) exit 1;;
  * ) exit 2;;
esac

function finish {
  change_namespace $env default
}
trap finish EXIT

change_namespace.sh $1 "$name"
if [ "$op" = "install" ]
then
  "${1}hh.sh" install "$name" ./grimoire/grimoire-chart $FLAGS --set api.url="$api_url",projectSlug="$slug", image.repository="$repository",image.account="$account",image.tag="$tag",identity.image.repository="$identity_repository",identity.image.account="$account",identity.image.tag="$identity_tag",identity.db.name="$identity_database"
elif [ "$op" = "upgrade" ]
then
  "${1}hh.sh" upgrade "$name" ./grimoire/grimoire-chart $FLAGS --reuse-values --set api.url="$api_url",projectSlug="$slug", image.repository="$repository",image.account="$account",image.tag="$tag",identity.image.repository="$identity_repository",identity.image.account="$account",identity.image.tag="$identity_tag",identity.db.name="$identity_database"
else
  echo "$0: unknown operation: $op"
  exit 9
fi
