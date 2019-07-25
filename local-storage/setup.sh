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
  # Eventually mkfs.xfs -f (to force create bFS even if FS already exists)
  ssh "ec2-user@${ip}" 'sudo mkfs -t xfs /dev/nvme0n1; sudo mkdir /data; sudo chmod ugo+rwx /data; echo "`sudo blkid /dev/nvme0n1 | awk '"'"'{print $2}'"'"'` /data xfs defaults 0 0" | sudo tee -a /etc/fstab; sudo mount /data'
done
