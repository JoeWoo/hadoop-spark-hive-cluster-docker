#!/bin/bash

# run N slave containers
N=$1

# the defaut node number is 3
if [ $# = 0 ]
then
	N=3
fi


# delete old master container and start new master container
sudo docker rm -f master &> /dev/null
echo "start master container..."
sudo docker run -d -t --dns 127.0.0.1 -P --name master -h master.bdp.com -w /root joewoo/hadoop-master:1.0 &> /dev/null

# get the IP address of master container
FIRST_IP=$(docker inspect --format="{{.NetworkSettings.IPAddress}}" master)

# init hive-mysql
echo "start hive-mysql container..."
sudo docker rm -f hive-mysql &> /dev/null
sudo docker run -d -t --dns 127.0.0.1 -P --name hive-mysql -h mysql.bdp.com -w /root -e JOIN_IP=$FIRST_IP joewoo/hive-mysql:1.0 &> /dev/null


# delete old slave containers and start new slave containers
i=1
while [ $i -lt $N ]
do
	sudo docker rm -f slave$i &> /dev/null
	echo "start slave$i container..."
	sudo docker run -d -t --dns 127.0.0.1 -P --name slave$i -h slave$i.bdp.com -e JOIN_IP=$FIRST_IP joewoo/hadoop-slave:1.0 &> /dev/null
	((i++))
done


# create a new Bash session in the master container
sudo docker exec -it master bash
