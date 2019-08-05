#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
. env.sh "$1" || exit 1
cd ~/dev/dev-analytics-terraform-stash || exit 2
# FIXME: prod has two folders, we're choosing first via 'head -n 1'
dir_name=`ls -d *.$TF_DIR | head -n 1`
echo $dir_name
if [ -z "$dir_name" ]
then
  echo "$0: cannot find deployment directory ($TF_DIR) for env $1"
  exit 3
fi
# FIXME: note that is is a very hacky way of getting AWS account and region - but I want to avoid hardcoding anything in a public repo
IFS=\. read -a ary <<<"$dir_name"
region="${ary[0]}"
n="${ary[1]}"
cd ~/dev/dev-analytics-api || exit 4
echo "docker build -t $n.dkr.ecr.$region.amazonaws.com/lfda/api:latest ."
docker build -t "$n.dkr.ecr.$region.amazonaws.com/lfda/api:latest" .
echo "aws ecr get-login --region $region --no-include-email"
aws ecr get-login --region $region --no-include-email
`aws ecr get-login --region $region --no-include-email`
echo "docker push $n.dkr.ecr.$region.amazonaws.com/lfda/api:latest"
docker push "$n.dkr.ecr.$region.amazonaws.com/lfda/api:latest"
docker system prune -f
