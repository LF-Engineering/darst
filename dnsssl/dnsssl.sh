#!/bin/bash
# ARN_ONLY=1 - only display ARN found and exit without patching the service
if [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if [ -z "$ARN_ONLY" ]
then
  if [ -z "$2" ]
  then
    echo "$0: you need to specify namespace as a 2nd arg"
    exit 2
  fi
  if [ -z "$3" ]
  then
    echo "$0: you need to specify service as a 3rd arg"
    exit 3
  fi
  if [ -z "$4" ]
  then
    echo "$0: you need to specify service DNS as a 4th arg"
    exit 4
  fi
fi
. env.sh "$1" || exit 1
wantdom="${TF_DIR}.lfanalytics.io"
if [ -z "$ARN_ONLY" ]
then
  if ( [[ ${4} == *".${wantdom}" ]] || [ "$4" = "$wantdom" ] )
  then
    echo "$4 belongs wildcard domain $wantdom, ok"
  else
    echo "$0: $4 doesn't belong to wildcard domain $wantdom, exiting"
    exit 5
  fi
fi
wantdom="\"$wantdom\""
i=0
while true
do
  dom=`"${1}aws.sh" acm list-certificates --certificate-statuses=ISSUED | jq ".CertificateSummaryList[$i].DomainName"`
  if [ "$dom" = "null" ]
  then
    break
  fi
  if [ "$dom" = "$wantdom" ]
  then
    arn=`"${1}aws.sh" acm list-certificates --certificate-statuses=ISSUED | jq ".CertificateSummaryList[$i].CertificateArn"`
    break
  fi
  i=$((i+1))
done
if [ -z "$arn" ]
then
  echo "$0: arn for $wantdom not found, exiting"
  exit 6
fi
echo "Found arn: $arn"
if [ ! -z "$ARN_ONLY" ]
then
  exit 0
fi
fn=/tmp/apply.yaml
function finish {
  # cat "$fn"
  rm -f "$fn" 2>/dev/null
}
trap finish EXIT
cp ./dnsssl/dnsssl.yaml "$fn"
arn="${arn//\//\\\/}"
arn="${arn//\./\\\.}"
host="${4//\./\\\.}"
vim --not-a-term -c "%s/SSLARN/${arn}/g" -c "%s/HOSTNAME/${host}/g" -c "%s/IMAGE/${DOCKER_USER}\/dev-analytics-ui/g" -c 'wq!' "$fn"
# "${1}k.sh" -n "$2" get svc "$3"
"${1}k.sh" -n "$2" patch svc "$3" --patch "`cat $fn`"
