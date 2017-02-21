# To build: docker build -t imhotep-daemon .
# To run: docker run --hostname=hadoop -v /path/to/host-volume-directory:/var/lib/hadoop-hdfs -d imhotep-daemon

FROM library/centos:centos6

# Install required packages
RUN yum update -y && yum install -y \
    nc \
    python-setuptools \
    util-linux-ng \
    wget

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

RUN useradd -r imhotep

RUN mkdir /opt/imhotep
RUN mkdir -p /var/data/indexes
RUN mkdir -p /var/data/imhotep/logs
RUN mkdir -p /var/data/imhotep/tmp
RUN chmod a+rw /var/data/imhotep
RUN chmod a+rw /var/data/indexes
RUN chmod a+rw /var/data/imhotep/logs
RUN chmod a+rw /var/data/imhotep/tmp

#RUN easy_install supervisor

#ADD supervisor/supervisord.conf /etc/supervisord.conf
#RUN mkdir /opt/supervisor
#ADD supervisor/imhotep.conf /opt/supervisor/imhotep.conf
#RUN chmod a+rw /opt/supervisor
#ADD supervisor/supervisor.init.sh /etc/init.d/supervisor
#RUN chmod a+x /etc/init.d/supervisor
#RUN chkconfig --level 345 supervisor on

RUN chown -R imhotep /var/data

RUN mkdir /var/tempFS && chown imhotep /var/tempFS && chgrp imhotep /var/tempFS

ADD log4j.xml /opt/imhotep/log4j.xml
ADD core-site.xml /opt/imhotep/core-site.xml

RUN mkdir -p /var/data/imhotep/source/target
ADD https://indeedeng-imhotep-build.s3.amazonaws.com/imhotep-server-1.0.10-SNAPSHOT-complete.tar.gz /var/data/imhotep/source/target/
RUN tar -xz -C /opt/imhotep/ -f /var/data/imhotep/source/target/imhotep-server-*.tar.gz
RUN ln -s /opt/imhotep/imhotep-server-* /opt/imhotep/imhotep-server

ADD imhotep.sh /opt/imhotep/imhotep.sh
ADD imhotep-debug.sh /opt/imhotep/imhotep-debug.sh
RUN chmod 0755 /opt/imhotep/imhotep*.sh

ADD imhotep-caching.yaml /opt/imhotep/imhotep-caching.yaml

RUN chown -R imhotep /opt/imhotep/
RUN chgrp -R imhotep /opt/imhotep/

WORKDIR /opt/imhotep

EXPOSE 12345

CMD /opt/imhotep/imhotep.sh
