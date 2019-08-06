#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi

# Mount NVMes in elastic node-group
for ip in `testk.sh get nodes -l lfda=grimoire -o wide | grep 'ip-' | awk '{print $7}'`
do
  echo "grimoire node group ip: $ip"
  ssh "ec2-user@${ip}" 'sudo vi -e -s -c "g/net\.core\.somaxconn/d" -c "g/vm\.overcommit_memory/d" -c "wq" /etc/rc.local'
done

