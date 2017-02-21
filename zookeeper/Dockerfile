FROM library/centos:centos6

# Install required packages
RUN yum update -y && yum install -y \
    wget \
&& yum clean all

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

ADD http://archive.cloudera.com/cdh5/cdh/5/zookeeper-3.4.5-cdh5.10.0.tar.gz /tmp/zookeeper.tar.gz
RUN tar -xz -C /opt/ -f /tmp/zookeeper.tar.gz && ln -s /opt/zookeeper-3.4.5-cdh5.10.0 /opt/zookeeper

RUN mkdir /var/zookeeper_snapshots

ADD zoo.cfg /opt/zookeeper/conf/zoo.cfg

RUN mkdir -p /var/data/zookeeper

WORKDIR /var/data/zookeeper

EXPOSE 2181

ENTRYPOINT ["/opt/zookeeper/bin/zkServer.sh"]
CMD ["start-foreground"]
