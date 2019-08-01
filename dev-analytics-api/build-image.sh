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
envd=$env
if [ "$envd" = "develop" ]
then
  envd=dev
fi
cd ~/dev/dev-analytics-terraform-stash || exit 2
dir_name=`ls -d *.$envd | head -n 1`
echo $dir_name
if [ -z "$dir_name" ]
then
  echo "$0: cannot find deployment directory for env $1"
  exit 3
fi
IFS=\. read -a ary <<<"$dir_name"
region="${ary[0]}"
n="${ary[1]}"
cd ~/dev/dev-analytics-api || exit 4
echo "docker build -t $n.dkr.ecr.$region.amazonaws.com/lfda/api:latest ."
docker build -t "$n.dkr.ecr.$region.amazonaws.com/lfda/api:latest" .
export AWS_PROFILE="lfproduct-$1"
echo "AWS_PROFILE=lfproduct-$1 aws ecr get-login --region $region --no-include-email"
aws ecr get-login --region $region --no-include-email
`aws ecr get-login --region $region --no-include-email`
echo "docker push $n.dkr.ecr.$region.amazonaws.com/lfda/api:latest"
docker push "$n.dkr.ecr.$region.amazonaws.com/lfda/api:latest"
