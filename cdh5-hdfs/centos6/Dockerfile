FROM local/imhotep-base-java7:centos6

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
