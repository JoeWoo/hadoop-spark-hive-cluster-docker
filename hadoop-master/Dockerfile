FROM joewoo/hadoop-base:1.0

MAINTAINER JoeWoo <0wujian0@gmail.com>

# move all confugration files into container
ADD files/* /tmp/

ENV HADOOP_INSTALL /usr/local/hadoop
ENV SPARK_INSTALL /usr/local/spark
ENV HIVE_INSTALL /usr/local/hive

RUN mkdir -p ~/hdfs/namenode && \
mkdir -p ~/hdfs/datanode && \
mkdir $HADOOP_INSTALL/logs

RUN mv /tmp/hdfs-site.xml $HADOOP_INSTALL/etc/hadoop/hdfs-site.xml && \
mv /tmp/core-site.xml $HADOOP_INSTALL/etc/hadoop/core-site.xml && \
mv /tmp/mapred-site.xml $HADOOP_INSTALL/etc/hadoop/mapred-site.xml && \
mv /tmp/yarn-site.xml $HADOOP_INSTALL/etc/hadoop/yarn-site.xml && \
mv /tmp/slaves $HADOOP_INSTALL/etc/hadoop/slaves && \
mv /tmp/start-hadoop.sh ~/start-hadoop.sh && \
mv /tmp/run-wordcount.sh ~/run-wordcount.sh && \
mv /tmp/start-ssh-serf.sh ~/start-ssh-serf.sh && \
mv /tmp/hive-site.xml $HIVE_INSTALL/conf/hive-site.xml &&\
mv /tmp/start-hive.sh ~/start-hive.sh

RUN mv /tmp/spark-slaves $SPARK_INSTALL/conf/slaves &&\
mv /tmp/start-spark.sh ~/start-spark.sh

RUN chmod +x ~/start-hadoop.sh && \
chmod +x ~/run-wordcount.sh && \
chmod +x ~/start-ssh-serf.sh && \
chmod +x ~/start-spark.sh && \
chmod 1777 tmp

# format namenode
RUN /usr/local/hadoop/bin/hdfs namenode -format

EXPOSE 22 7373 7946 9000 50010 50020 50070 50075 50090 50475 8030 8031 8032 8033 8040 8042 8060 8088 50060 8080 10000 9999

CMD '/root/start-ssh-serf.sh'; 'bash'
