FROM library/centos:centos6
RUN yum update -y
RUN yum install -y wget
RUN wget --no-cookies --no-check-certificate --header 'Cookie: oraclelicense=accept-securebackup-cookie' 'http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.rpm'
RUN yum localinstall -y jdk-7u55-linux-x64.rpm
RUN alternatives --install /usr/bin/java java /usr/java/jdk1.7.0_55/jre/bin/java 20000 \
                 --slave /usr/bin/keytool keytool /usr/java/jdk1.7.0_55/jre/bin/keytool \
                 --slave /usr/bin/orbd orbd /usr/java/jdk1.7.0_55/jre/bin/orbd \
                 --slave /usr/bin/pack2000 pack2000 /usr/java/jdk1.7.0_55/jre/bin/pack200 \
                 --slave /usr/bin/rmid rmid /usr/java/jdk1.7.0_55/jre/bin/rmid \
                 --slave /usr/bin/rmiregistry rmiregistry /usr/java/jdk1.7.0_55/jre/bin/rmiregistry \
                 --slave /usr/bin/servertool servertool /usr/java/jdk1.7.0_55/jre/bin/servertool \
                 --slave /usr/bin/tnameserv tnameserv /usr/java/jdk1.7.0_55/jre/bin/tnameserv \
                 --slave /usr/bin/unpack2000 unpack2000 /usr/java/jdk1.7.0_55/jre/bin/unpack200
RUN wget -O /tmp/zookeeper.tar.gz http://archive.cloudera.com/cdh4/cdh/4/zookeeper-3.4.5-cdh4.4.0.tar.gz
RUN cd /opt && tar xzf /tmp/zookeeper.tar.gz && ln -s zookeeper-3.4.5-cdh4.4.0 zookeeper
RUN mkdir /var/zookeeper_snapshots
RUN printf "tickTime=2000\ninitLimit=10\nsyncLimit=5\ndataDir=/var/zookeeper_snapshots\nclientPort=2181" > /tmp/zoo.cfg
RUN mv /tmp/zoo.cfg /opt/zookeeper/conf
RUN mkdir -p /var/data/zookeeper

WORKDIR /var/data/zookeeper

EXPOSE 2181

ENTRYPOINT ["/opt/zookeeper/bin/zkServer.sh"]
CMD ["start-foreground"]
