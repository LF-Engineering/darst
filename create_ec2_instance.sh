#!/bin/bash
if [ -z "$AWS_PROFILE" ]
then
  echo "$0: you need to specify AWS_PROFILE=... to run this script"
  exit 1
fi
#aws ec2 create-security-group --group-name SSHSecurityGroup --description "Allow port 22"
#aws ec2 authorize-security-group-ingress --group-name SSHSecurityGroup --protocol tcp --port 22 --cidr 0.0.0.0/0
#aws ec2 describe-security-groups --group-names SSHSecurityGroup
