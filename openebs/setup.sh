#!/bin/bash
#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if [ ! -z "$OPERATOR" ]
then
  "${1}k.sh" apply -f https://openebs.github.io/charts/openebs-operator-1.6.0.yaml
fi
"${1}h.sh" install local-storage-nfs stable/nfs-server-provisioner --set=persistence.enabled=true,persistence.storageClass=openebs-hostpath,persistence.size=4Gi,storageClass.name=nfs-openebs-localstorage
