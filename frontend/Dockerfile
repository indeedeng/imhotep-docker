FROM library/centos:centos6
RUN yum update -y
RUN useradd shardbuilder
RUN useradd tomcat7
RUN yum install -y wget httpd cronie procmail
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

RUN echo "*/1  *  *  *  * shardbuilder /opt/imhotepTsvConverter/tsvConverter.sh" >> /etc/crontab

RUN wget -O /tmp/tomcat7.tar.gz http://www.us.apache.org/dist/tomcat/tomcat-7/v7.0.75/bin/apache-tomcat-7.0.75.tar.gz
RUN cd /tmp && tar xzf tomcat7.tar.gz && mv apache-tomcat-7.0.75 /opt/tomcat7
RUN mkdir /opt/tomcat_shared
ADD tomcat/catalina.properties /opt/tomcat7/conf/catalina.properties
ADD tomcat/server.xml /opt/tomcat7/conf/server.xml
ADD tomcat/tomcat7.conf /opt/tomcat7/conf/tomcat7.conf
ADD tomcat/init-script /etc/init.d/tomcat
ADD core-site.xml /opt/tomcat_shared/core-site.xml
RUN chmod +x /etc/init.d/tomcat
RUN chown -R tomcat7 /opt/tomcat7
RUN chown -R tomcat7 /opt/tomcat_shared
RUN mkdir -p /etc/httpd/conf
RUN mkdir -p /etc/httpd/conf.d
ADD apache/httpd.conf /etc/httpd/conf/httpd.conf

ADD iql.properties /opt/tomcat7/conf/iql.properties
ADD iupload.properties /opt/tomcat7/conf/iupload.properties
ADD zookeeper.ip /opt/tomcat7/conf/zookeeper.ip

RUN mkdir -p /opt/imhotepTsvConverter
RUN cd /opt/imhotepTsvConverter
RUN wget -O /tmp/tsv-builder.tar.gz https://indeedeng-imhotep-build.s3.amazonaws.com/tsv-builder-1.0.0-complete.tar.gz
RUN tar xzf /tmp/tsv-builder.tar.gz
RUN ln -s /opt/imhotepTsvConverter/tsv-builder-* /opt/imhotepTsvConverter/shardBuilder
RUN mkdir /opt/imhotepTsvConverter/conf
RUN chown shardbuilder /opt/imhotepTsvConverter/conf
ADD tsvConverter.sh /opt/imhotepTsvConverter/tsvConverter.sh
RUN chmod +x /opt/imhotepTsvConverter/tsvConverter.sh
ADD core-site.xml /opt/imhotepTsvConverter/conf/core-site.xml
RUN mkdir /opt/imhotepTsvConverter/logs
RUN chown -R shardbuilder /opt/imhotepTsvConverter
RUN mkdir -p /var/data/build
RUN chmod go+w /var/data/build

RUN mkdir -p /var/data/iql/ramses_metadata
RUN chmod go+w /var/data/
RUN chmod go+w /var/data/iql/
RUN chmod go+w /var/data/iql/ramses_metadata
RUN mkdir -p /var/data/tomcat7/temp
RUN chmod go+w /var/data/tomcat7
RUN chmod go+w /var/data/tomcat7/temp
RUN chown -R tomcat7 /var/data/tomcat7
RUN mkdir -p /var/data/iql/local_cache
RUN chmod go+w /var/data/iql/local_cache
RUN wget -O /tmp/iql.war https://indeedeng-imhotep-build.s3.amazonaws.com/iql-1.0.5-SNAPSHOT.war
RUN cp /tmp/iql.war /opt/tomcat7/webapps/

#RUN sed -i 's/^CATALINA_TMPDIR=.*/CATALINA_TMPDIR=\"\/var\/data\/tomcat7\/temp\"/' /opt/tomcat7/conf/tomcat7.conf

RUN wget -O /tmp/iupload.war https://indeedeng-imhotep-build.s3.amazonaws.com/iupload-war-1.0.1-SNAPSHOT.war
RUN cp /tmp/iupload.war /opt/tomcat7/webapps/

RUN mkdir -p /var/data/hdfs-tmp
RUN chmod go+w /var/data/hdfs-tmp

RUN mkdir /var/data/apache
RUN chmod go+rw /var/data/apache
RUN cd /var/data/apache

WORKDIR /opt/imhotepTsvConverter

EXPOSE 80

CMD crond && crontab /etc/crontab && service httpd start && service tomcat start && bash
