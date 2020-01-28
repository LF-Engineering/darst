#!/bin/bash
export AWS_PROFILE=darst
# aws ec2 create-volume --availability-zone us-west-2b --size 80
# aws ec2 attach-volume --volume-id vol-061c50e7bc0910c24 --instance-id i-0753c51710f323365 --device /dev/sdf
# lsblk
# sudo mkfs -t xfs /dev/xvdf
# mount /data
# mount /dev/xvdf /data
# Delete:
# aws ec2 detach-volume --volume-id vol-061c50e7bc0910c24 --instance-id i-0753c51710f323365
# aws ec2 delete-volume --volume-id vol-061c50e7bc0910c24
