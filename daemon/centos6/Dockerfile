FROM local/imhotep-base-java7:centos6

# Install required packages
RUN yum update -y && yum install -y \
    nc \
    python-setuptools \
    util-linux-ng

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
ADD https://indeedeng-imhotep-build.s3.amazonaws.com/imhotep-server-1.0.11-SNAPSHOT-complete.tar.gz /var/data/imhotep/source/target/
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
