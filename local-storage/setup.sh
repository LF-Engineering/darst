#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}k.sh" apply -f local-storage/storage-class.yaml
for ip in `"${1}k.sh" get nodes -l lfda=elastic -o wide | grep 'ip-' | awk '{print $7}'`
do
  echo "IP: $ip"
  ssh "ec2-user@${ip}" 'sudo mkdir /data; sudo chmod ugo+rwx /data'
done
