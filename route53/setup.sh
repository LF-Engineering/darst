#!/bin/bash
if [ -z "$1" ]
then
  echo "$0: you need to specify env: test, dev, stg, prod"
  exit 1
fi
if [ -z "$2" ]
then
  echo "$0: you need to specify service namespace as a 2nd arg"
  exit 2
fi
if [ -z "$3" ]
then
  echo "$0: you need to specify service name as a 3rd arg"
  exit 3
fi
. env.sh "$1" || exit 1
if [ -z "$4" ]
then
  echo "$0: you need to specify subdomain name, for example: api, ui, elastic"
  echo "The final requested name will be subdomain.${TF_DIR}.lfanalytics.io"
  exit 4
fi
lb_url=`"${1}k.sh" -n "$2" get svc "$3" -o jsonpath={.status.loadBalancer.ingress[0].hostname}`
lb_temp=`echo $lb_url | cut -d "." -f 1`
lb_name=`echo $lb_temp | cut -d "-" -f 1`
zid=`"${1}aws.sh" elb describe-load-balancers --load-balancer-names=${lb_name} --query "LoadBalancerDescriptions[0].CanonicalHostedZoneNameID" --output text`
if [ -z "$zid" ]
then
  echo "$0: cannot find hosted zone ID"
  exit 5
fi
fn=config.json
function finish {
  # cat "$fn"
  rm -f "$fn" 2>/dev/null
}
trap finish EXIT
sub=$4
echo "Configuring ${4}.${TF_DIR}.lfanalytics.io"
cat > "$fn" <<EOF
{
   "Comment": "Creating Alias resource record sets in Route 53",
   "Changes": [{
    "Action": "CREATE",
    "ResourceRecordSet": {
          "Name": "${sub}.${TF_DIR}.lfanalytics.io",
          "Type": "A",
          "AliasTarget":{
              "HostedZoneId": "${zid}",
              "DNSName": "dualstack.${lb_url}",
              "EvaluateTargetHealth": false
          }}
   }]
}
EOF
"${1}aws.sh" route53 change-resource-record-sets --hosted-zone-id ${zid} --change-batch "file://$fn" || cat "$fn"
