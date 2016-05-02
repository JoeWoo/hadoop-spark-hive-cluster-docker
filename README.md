

Quickly build arbitrary size Hadoop Cluster, Spark Cluster, Hive based on Docker
------

```
1. Project Introduction
2. BDP-Cluster-Docker image Introduction
3. Steps to build a 3 nodes Cluster and Hive MySql MetaStore
4. Steps to build an arbitrary size Cluster
```

##1. Project Introduction

The objective of this project is to help Hadoop developer to quickly build an arbitrary size Hadoop cluster on their local host. This is achieved by using [Docker](https://www.docker.com/).

My project is based on [kiwenlau/hadoop-cluster-docker]https://github.com/kiwenlau/hadoop-cluster-docker project, however, I've added Spark and Hive and changed the base os from Ubuntu-15.04 to CentOS-6.


##2. BDP-Cluster-Docker image Introduction
BDP is short for Big Data Platform
In this project, I developed 5 docker images: **serf-dnsmasq**, **hive-mysql**, **hadoop-base**, **hadoop-master** and **hadoop-slave**.

#####1. serf-dnsmasq

Based on [centos:6](https://hub.docker.com/_/centos/). [serf](https://www.serfdom.io/) and [dnsmasq](http://www.thekelleys.org.uk/dnsmasq/doc.html) are installed for providing DNS service for the Hadoop Cluster.

#####2. hive-mysql
For hive metastore.
Based on serf-dnsmasq.
Installed:
```
openssh-server
openssh-client
vim
mysql
```
#####3. hadoop-base

Based on serf-dnsmasq.
installed:
```
java-1.7.0-openjdk
scala-2.10.4
openssh-server
openssh-client
vim
Apache Hadoop 2.6.4
Apache Hive 1.2.1
Apache Spark 1.5.2
```

#####4. hadoop-master

Based on hadoop-base.
Runs :
```
Hadoop master node
Spark master node
Hive CLI
Hive HWI
Hive hiveserver2
```

#####5.hadoop-slave

Based on hadoop-base.
Runs:
```
Hadoop slave node
Spark slave node
```

##3. steps to build Cluster

#####a. clone source code
a large repo... this could take a while
```
git clone https://github.com/JoeWoo/hadoop-spark-hive-cluster-docker
```
download hadoop, spark, hive bin files:
```
cd hadoop-spark-hive-cluster-docker/hadoop-base/files

curl -Lso hadoop-2.6.4.tar.gz http://ftp.tsukuba.wide.ad.jp/software/apache/hadoop/common/hadoop-2.6.4/hadoop-2.6.4.tar.gz
tar -zxvf hadoop-2.6.4.tar.gz
rm hadoop-2.6.4.tar.gz

curl -Lso spark-1.5.2-bin-hadoop2.6.tgz http://mirror.cogentco.com/pub/apache/spark/spark-1.5.2/spark-1.5.2-bin-hadoop2.6.tgz
tar -zxvf  spark-1.5.2-bin-hadoop2.6.tgz
rm spark-1.5.2-bin-hadoop2.6.tgz

curl -Lso apache-hive-1.2.1-bin.tar.gz http://mirror.tcpdiag.net/apache/hive/hive-1.2.1/apache-hive-1.2.1-bin.tar.gz
tar -zxvf apache-hive-1.2.1-bin.tar.gz
rm apache-hive-1.2.1-bin.tar.gz


```

#####b. build images
```
 cd hadoop-spark-hive-cluster-docker
./build-image.sh
```
#####c. check building result
```
$ docker images
```
*output:*
```
joewoo/hadoop-slave                     1.0                 29dcd2a776f5        About an hour ago   1.373 GB
joewoo/hadoop-master                    1.0                 f9b3bdaa3db6        About an hour ago   1.373 GB
joewoo/hadoop-base                      1.0                 291016ffe302        About an hour ago   1.373 GB
joewoo/hive-mysql                       1.0                 0e5af7734696        2 hours ago         570.8 MB
joewoo/serf-dnsmasq                     1.0                 f055d3ced087        2 hours ago         335.4 MB
```
Tips:

 - if you use boot2docker install bash first.
```
tce
> S
> Enter starting chars of desired extension, e.g. abi: bash
>
> tce - Tiny Core Extension browser
>
>	 1. bash-completion.tcz
>	 2. bash.tcz
>
> Enter selection ( 1 - 2 ) or (q)uit: 1
> A)bout I)nstall O)nDemand D)epends T)ree F)iles siZ)e L)ist S)earch P)rovides K)eywords or Q)uit: I
> exit
```  
- In China, to speeding up `pull centos:6 docker`  by some docker hub mirrors like :[daoCloud](https://dashboard.daocloud.io/mirror). Sometimes, `yum install` also not works so well, just try one more time.

#####d. run container
```
 cd hadoop-spark-hive-cluster-docker
./start-container.sh
```

*output:*

```
start master container...
start slave1 container...
start slave2 container...
root@master:~#
```
- start 4 containers，1 master, 2 slaves and 1 mysql
- you will go to the /root directory of master container after start all containers

*list the files inside /root directory of master container*

```
ls
```

*output*

```
hdfs  run-wordcount.sh    serf_log  start-hadoop.sh  start-spark.sh start-hive.sh  start-ssh-serf.sh
```

#####e. test serf and dnsmasq service

- In fact, you can skip this step and just wait for about 1 minute. Serf and dnsmasq need some time to start service.

*list all nodes of hadoop cluster*

```
serf members
```

*output*

```
master.bdp.com  172.17.0.3:7946  alive
slave1.bdp.com  172.17.0.5:7946  alive
slave2.bdp.com  172.17.0.6:7946  alive
mysql.bdp.com   172.17.0.4:7946  alive
```
- you can wait for a while if any nodes don't show up since serf agent need time to recognize all nodes

*test ssh*

```
ssh slave2.bdp.com
```

*exit slave2 nodes*

```
exit
```

*output*

```
logout
Connection to slave2.bdp.com closed.
```
- Please wait for a whil if ssh fails, dnsmasq need time to configure domain name resolution service
- You can start hadoop after these tests!

#####f. start hadoop
```
./start-hadoop.sh
```


#####g. run wordcount
```
./run-wordcount.sh
```

*output*

```
input file1.txt:
Hello Hadoop

input file2.txt:
Hello Docker

wordcount output:
Docker    1
Hadoop    1
Hello    2
```
####h. start spark
```
./start-spark.sh
```

####i. run spark example
```
spark-shell
>val file=sc.textFile("hdfs://master.bdp.com:9000/user/root/input/README.txt")  
>val count=file.flatMap(line => line.split(" ")).map(word => (word,1)).reduceByKey(_+_)  
>count.collect
```

####j. start hive
```
./start-hive.sh
```
####k. run hive
```
hive
```
##4. Steps to build arbitrary size Hadoop cluster

#####a. Preparation

- check the steps a~b of section 3：pull images and clone source code

#####b. rebuild hadoop-master

```
./resize-cluster.sh 5
```

- you can use any interger as the parameter for resize-cluster.sh: 1, 2, 3, 4, 5, 6...


#####c. start container
```
./start-container.sh 5
```
- you'd better use the same parameter as the step b

#####d. run the cluster

- check the steps d~k of section 3：test serf and dnsmasq,  start Hadoop and run wordcount
- please test serf and dnsmasq service before start hadoop
