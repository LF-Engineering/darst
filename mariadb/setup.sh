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
change_namespace.sh $1 mariadb
"${1}k.sh" -n mariadb create -f "$fn"
"${1}h.sh" -n mariadb install mariadb stable/mariadb
change_namespace.sh $1 default
