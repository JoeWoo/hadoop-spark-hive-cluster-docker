#!/bin/bash

# start sshd
echo "start sshd..."
service sshd start

# start sef
echo -e "\nstart serf..."
/etc/serf/start-serf-agent.sh > serf_log &

sleep 5

serf members

echo -e "\nbdp-cluster-docker developed by JoeWoo <0wujian0@gmail.com>"
