#!/bin/bash

# start sshd
echo "start sshd..."
service sshd start
echo "start mysqld..."
service mysqld start
sleep 5

#/etc/init.d/mysqld start
echo -e "\nset mysql root password..."
mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('root')"
# init hive-mysql
echo -e "\ninit mysql for hive metastore..."
mysql -uroot -proot -e "create database hive;"
mysql -uroot -proot -e "grant all privileges on hive.* to 'hive_user'@'%' identified by 'hive_password';flush privileges;"

# start sef
echo -e "\nstart serf..."
/etc/serf/start-serf-agent.sh > serf_log &

sleep 5

serf members

echo -e "\nbdp-cluster-docker developed by JoeWoo <0wujian0@gmail.com>"
