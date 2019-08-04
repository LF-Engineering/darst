#!/bin/bash
env="$1"
foundation="$2"
project="$3"
if [ -z "$env" ]
then
  echo "$0: you need to provide env as 1st arg: test, dev, stg, prod"
  exit 1
fi
if [ -z "$foundation" ]
then
  echo "$0: you need to provide foundation as 3rd arg or use none for LF"
  exit 2
fi
if [ -z "$project" ]
then
  echo "$0: you need to provide project as 4th arg"
  exit 3
fi
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
echo "Deleting $name $slug"
change_namespace.sh $1 "$name"
helm delete "$name"
change_namespace.sh $ default
