#!/bin/bash
if  [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
fn=/tmp/apply.yaml
function finish { 
  rm -f "$fn" 2>/dev/null
}
trap finish EXIT
cp mariadb/secret.yaml "$fn"
pass=`cat mariadb/PASS.secret | base64`
pass_root=`cat mariadb/PASS_ROOT.secret | base64`
pass_rep=`cat mariadb/PASS_REP.secret | base64`
if ( [ -z "$pass" ] || [ -z "$pass_root" ] || [ -z "$pass_rep" ] )
then
  echo "$0: you need to provide password values in mariadb/PASS.secret, mariadb/PASS_ROOT.secret, mariadb/PASS_REP.secret files"
  exit 1
fi
vim --not-a-term -c "%s/PASS_MAIN/${pass}/g" --not-a-term -c "%s/PASS_ROOT/${pass_root}/g" --not-a-term -c "%s/PASS_REP/${pass_rep}/g" -c 'wq!' "$fn"
"${1}k.sh" create -f mariadb/namespace.yaml
change_namespace.sh $1 mariadb
"${1}k.sh" -n mariadb create -f "$fn"
db=`cat mariadb/DB.secret`
usr=`cat mariadb/USER.secret`
"${1}h.sh" -n mariadb install mariadb stable/mariadb --set "existingSecret=mariadb,db.name=${db},db.user=${usr},master.nodeSelector.lfda=grimoire,master.persistence.storageClass=openebs-hostpath,master.persistence.size=4Gi,master.resources.requests.cpu=250m,master.resources.requests.memory=256Mi,master.resources.limits.cpu=2000m,master.resources.limits.memory=2Gi,slave.replicas=1,slave.nodeSelector.lfda=grimoire,slave.persistence.storageClass=openebs-hostpath,slave.persistence.size=4Gi,slave.resources.requests.cpu=250m,slave.resources.requests.memory=256Mi,slave.resources.limits.cpu=2000m,slave.resources.limits.memory=2Gi"
change_namespace.sh $1 default
