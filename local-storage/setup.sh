#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}k.sh" apply -f local-storage/storage-class.yaml

# Mount NVMes in elastic node-group
for ip in `"${1}k.sh" get nodes -l lfda=elastic -o wide | grep 'ip-' | awk '{print $7}'`
do
  echo "IP: $ip"
  # Eventually mkfs.xfs -f (to force create bFS even if FS already exists)
  ssh "ec2-user@${ip}" 'sudo mkfs -t xfs /dev/nvme0n1; sudo mkdir /var/openebs; sudo chmod ugo+rwx /var/openebs; echo "`sudo blkid /dev/nvme0n1 | awk '"'"'{print $2}'"'"'` /var/openebs xfs defaults 0 0" | sudo tee -a /etc/fstab; sudo mount /openebs'
done

# Mount NVMes in devstats node-group
for ip in `"${1}k.sh" get nodes -l lfda=devstats -o wide | grep 'ip-' | awk '{print $7}'`
do
  echo "IP: $ip"
  # Eventually mkfs.xfs -f (to force create bFS even if FS already exists)
  ssh "ec2-user@${ip}" 'sudo mkfs -t xfs /dev/nvme0n1; sudo mkdir /var/openebs; sudo chmod ugo+rwx /var/openebs; echo "`sudo blkid /dev/nvme0n1 | awk '"'"'{print $2}'"'"'` /var/openebs xfs defaults 0 0" | sudo tee -a /etc/fstab; sudo mount /var/openebs'
done

# Mount NVMes in grimoire node-group
for ip in `"${1}k.sh" get nodes -l lfda=grimoire -o wide | grep 'ip-' | awk '{print $7}'`
do
  echo "IP: $ip"
  # Eventually mkfs.xfs -f (to force create bFS even if FS already exists)
  ssh "ec2-user@${ip}" 'sudo mkfs -t xfs /dev/nvme1n1; sudo mkdir /var/openebs; sudo chmod ugo+rwx /var/openebs; echo "`sudo blkid /dev/nvme1n1 | awk '"'"'{print $2}'"'"'` /var/openebs xfs defaults 0 0" | sudo tee -a /etc/fstab; sudo mount /var/openebs'
done
