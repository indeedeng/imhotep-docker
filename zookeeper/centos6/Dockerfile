FROM local/imhotep-base-java7:centos6

ADD http://archive.cloudera.com/cdh5/cdh/5/zookeeper-3.4.5-cdh5.10.0.tar.gz /tmp/zookeeper.tar.gz
RUN tar -xz -C /opt/ -f /tmp/zookeeper.tar.gz && ln -s /opt/zookeeper-3.4.5-cdh5.10.0 /opt/zookeeper

RUN mkdir /var/zookeeper_snapshots

ADD zoo.cfg /opt/zookeeper/conf/zoo.cfg

RUN mkdir -p /var/data/zookeeper

WORKDIR /var/data/zookeeper

EXPOSE 2181

ENTRYPOINT ["/opt/zookeeper/bin/zkServer.sh"]
CMD ["start-foreground"]
