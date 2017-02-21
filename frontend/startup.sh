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

service crond start
service httpd start
service tomcat start

while [ -true ]; do
    sleep 30
done
