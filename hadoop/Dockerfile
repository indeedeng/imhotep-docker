# To build: docker build -t imhotep-cdh-hdfs .
# To run: docker run --hostname=hadoop -v /path/to/host-volume-directory:/var/lib/hadoop-hdfs -d imhotep-cdh-hdfs

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

ADD https://archive.cloudera.com/cdh5/one-click-install/redhat/6/x86_64/cloudera-cdh-5-0.x86_64.rpm /tmp/cloudera-cdh-5-0.x86_64.rpm
RUN yum --nogpgcheck localinstall -y /tmp/cloudera-cdh-5-0.x86_64.rpm
RUN rpm --import https://archive.cloudera.com/cdh5/redhat/6/x86_64/cdh/RPM-GPG-KEY-cloudera 
RUN yum install -y hadoop-0.20-conf-pseudo && yum clean all

RUN sed -i "s/localhost/hadoop/" /etc/hadoop/conf/core-site.xml
RUN sed -i "s/<\/configuration/<\property>\n\t<name>fs.permissions.umask-mode<\/name>\n\t<value>002<\/value>\n<\/property>\n<\/configuration/" /etc/hadoop/conf/hdfs-site.xml

ADD hdfs-start.sh /usr/bin/hdfs-start.sh
RUN chmod 0755 /usr/bin/hdfs-start.sh

EXPOSE 8020

CMD hdfs-start.sh 
