#!/bin/bash
cd /root/dev/darst || exit 1
testk.sh -n kibana delete po --all
prodk.sh -n kibana delete po --all
