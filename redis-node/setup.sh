#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi

# Sysctls and disable THP
for ip in `"${1}k.sh" get nodes -l lfda=grimoire -o wide | grep 'ip-' | awk '{print $7}'`
do
  echo "grimoire node group ip: $ip"
  ssh "ec2-user@${ip}" 'sudo sysctl -w net.core.somaxconn=65535; sudo sysctl -w vm.overcommit_memory=1; sudo vi -e -s -c "g/net\.core\.somaxconn/d" -c "g/vm\.overcommit_memory/d" -c "wq" /etc/rc.local; echo "sysctl -w net.core.somaxconn=65535" | sudo tee -a /etc/rc.local; echo "sysctl -w vm.overcommit_memory=1" | sudo tee -a /etc/rc.local; echo "never" | sudo tee /sys/kernel/mm/transparent_hugepage/enabled'
done

