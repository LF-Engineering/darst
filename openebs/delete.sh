#!/bin/bash
#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
"${1}h.sh" delete local-storage-nfs
"${1}k.sh" delete pvc `"${1}k.sh" get pvc | grep nfs | awk '{print $1}'`
"${1}k.sh" delete pv `"${1}k.sh" get pvc | grep nfs | awk '{print $1}'`
"${1}k.sh" delete -f https://openebs.github.io/charts/openebs-operator-1.0.0.yaml
