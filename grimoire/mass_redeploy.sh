#!/bin/bash
if [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if [ -z "$2" ]
then
  echo "$0: you need to specify single hit project query/queries"
  exit 2
fi
for proj in $2
do
  echo "Project $proj"
  n=`./grimoire/projects.sh "$1" | grep "$proj" | wc -l`
  if [ ! "$n" = "1" ]
  then
    echo "No project found or multiple projects found:"
    ./grimoire/projects.sh "$1" | grep "$proj"
    continue
  fi
  slug=`LIST=slug ./grimoire/projects.sh "$1" | grep "$proj"`
  echo "Slug: $slug"
  IFS=\/ read -a ary <<<"$slug"
  f=${ary[0]}
  n=${ary[1]}
  if [ -z "$n" ]
  then
    n="$f"
    f="lf"
  fi
  echo "Name: $n"
  echo "Foundation: $f"
  ns="g-${f}-${n}"
  echo "Namespace: $ns"
  "${1}k.sh" get po -n "$ns" | grep 'mordred\|arthur\|identity-api'
  pods=''
  for pod in `"${1}k.sh" get po -n "$ns" -o custom-columns=:metadata.name | grep 'mordred\|arthur\|identity-api'`
  do
    if [ -z "$pods" ]
    then
      pods=$pod
    else
      pods="$pods $pod"
    fi
  done
  echo "${1}k.sh -n "$ns" delete pods $pods"
  "${1}k.sh" -n "$ns" delete pods $pods
  "${1}k.sh" get po -n "$ns" | grep 'mordred\|arthur\|identity-api'
done
echo 'Finshed'
