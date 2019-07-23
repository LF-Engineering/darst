#!/bin/bash
echo 'User darst'
ssh-copy-id darst@ec2-52-39-54-150.us-west-2.compute.amazonaws.com
echo 'User ubuntu'
ssh-copy-id ubuntu@ec2-52-39-54-150.us-west-2.compute.amazonaws.com
echo 'User root'
ssh-copy-id root@ec2-52-39-54-150.us-west-2.compute.amazonaws.com
