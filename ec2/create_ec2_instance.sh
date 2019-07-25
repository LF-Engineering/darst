#!/bin/bash
if [ -z "$AWS_PROFILE" ]
then
  echo "$0: you need to specify AWS_PROFILE=... to run this script"
  exit 1
fi
aws ec2 create-security-group --group-name SSHSecurityGroup --description "Allow port 22"
aws ec2 authorize-security-group-ingress --group-name SSHSecurityGroup --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 describe-security-groups --group-names SSHSecurityGroup
aws ec2 create-key-pair --key-name DarstKey --query 'KeyMaterial' --output text > DaRstKey.pem
aws ec2 describe-key-pairs --key-name DarstKey
# aws ec2 describe-images --owners self amazon
#aws ec2 run-instances --image-id ami-07b4f3c02c7f83d59 --key-name DarstKey --security-groups SSHSecurityGroup --instance-type t2.medium --placement AvailabilityZone=us-west-2b --block-device-mappings DeviceName=/dev/sdh,Ebs={VolumeSize=100} --count 2
aws ec2 run-instances --image-id ami-07b4f3c02c7f83d59 --key-name DarstKey --security-groups SSHSecurityGroup --instance-type t2.medium
aws ec2 describe-instances
echo 'Wait few minutes and then run ssh_into_ec2_pem.sh or ssh_into_ec2.sh'
