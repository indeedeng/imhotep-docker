#!/bin/bash

sleeptime=10
attempts=10
while [ $attempts -gt 0 ]; do
    sleep $sleeptime
    echo -n "Checking zookeeper... "
    /usr/bin/nc -z zookeeper 2181
    zk=$?
    echo -n "Checking hdfs... "
    /usr/bin/nc -z hadoop 8020
    hdp=$?
    if [ $((zk+hdp)) -eq 0 ]; then
        break
    fi
    attempts=$((attempts-1))
    if [ $attempts -eq 0 ]; then
        echo "Giving up on dependent services"
        exit 1
    fi
done


export CLASSPATH="/opt/imhotep:/opt/imhotep/imhotep-server/lib/*:"$CLASSPATH

java -Xmx5G -Dlog4j.configuration=file:///opt/imhotep/log4j.xml -Djava.io.tmpdir=/var/data/imhotep/tmp -Dcom.indeed.flamdex.simple.useNative=true -Dcom.indeed.flamdex.simple.useSSSE3=true com.indeed.imhotep.service.ImhotepDaemon /imhotep/imhotep-data /var/tempFS --port 12345 --memory $((5 * 1024 - 512)) --zknodes zookeeper:2181 --zkpath /imhotep/daemons --lazyLoadProps /opt/imhotep/imhotep-caching.yaml
