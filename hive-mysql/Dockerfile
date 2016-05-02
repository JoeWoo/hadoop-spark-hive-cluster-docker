FROM joewoo/serf-dnsmasq:1.0

MAINTAINER JoeWoo <0wujian0@gmail.com>

# install openssh-server, vim and openjdk
RUN yum provides '*/applydeltarpm'
RUN yum install -y deltarpm
RUN yum install -y openssh-server vim
RUN yum install -y mysql mysql-server mysql-devel
#RUN groupadd mysql && \
#useradd -g mysql mysql
#RUN chgrp -R mysql /var/lib/mysql
#RUN chmod -R 770 /var/lib/mysql


# move all configuration files into container
ADD files/* /usr/local/

#configure ssh free key access
RUN mkdir /var/run/sshd && \
ssh-keygen -t rsa -f ~/.ssh/id_rsa -P '' && \
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys && \
mv /usr/local/ssh_config ~/.ssh/config && \
sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

RUN mv /usr/local/start-mysql.sh ~/start-mysql.sh && \
chmod +x ~/start-mysql.sh

EXPOSE 3306

RUN mv /usr/local/start-ssh-serf.sh ~/start-ssh-serf.sh && \
chmod +x ~/start-ssh-serf.sh

CMD '/root/start-ssh-serf.sh'; 'bash'
