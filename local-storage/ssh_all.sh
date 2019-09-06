#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}k.sh" apply -f local-storage/storage-class.yaml

# elastic node-group
for ip in `"${1}k.sh" get nodes -l lfda=elastic -o wide | grep 'ip-' | awk '{print $7}'`
do
  echo "elastic node group ip: $ip"
  ssh "ec2-user@${ip}"
done

# devstats node-group
for ip in `"${1}k.sh" get nodes -l lfda=devstats -o wide | grep 'ip-' | awk '{print $7}'`
do
  echo "devstats node group ip: $ip"
  ssh "ec2-user@${ip}"
done

# grimoire node-group
for ip in `"${1}k.sh" get nodes -l lfda=grimoire -o wide | grep 'ip-' | awk '{print $7}'`
do
  echo "grimoire node group ip: $ip"
  ssh "ec2-user@${ip}"
done

# app node-group
for ip in `"${1}k.sh" get nodes -l lfda=app -o wide | grep 'ip-' | awk '{print $7}'`
do
  echo "app node group ip: $ip"
  ssh "ec2-user@${ip}"
done
