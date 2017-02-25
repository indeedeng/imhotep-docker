#!/bin/sh

if [ ! -d /var/lib/hadoop-hdfs/cache/hdfs ]; then
    echo "Initializing HDFS..."

    chown -R hdfs.hadoop /var/lib/hadoop-hdfs

    su hdfs -c "hdfs namenode -format"
    service hadoop-hdfs-namenode stop
fi

for x in `cd /etc/init.d ; ls hadoop-hdfs-*` ; do
    service $x start
done

su hdfs -c "/usr/bin/hdfs dfs -ls /imhotep" 2> /dev/null > /dev/null
if [ "$?" != 0 ]; then
    echo "Setting up typical users"
    useradd tomcat7
    useradd shardbuilder
    groupadd imhotep
    usermod -G imhotep tomcat7
    usermod -G imhotep shardbuilder
    usermod -G imhotep hdfs
    su hdfs -c "/usr/bin/hdfs dfs -mkdir -p /user/tomcat7"
    su hdfs -c "/usr/bin/hdfs dfs -chown tomcat7:imhotep /user/tomcat7"
    su hdfs -c "/usr/bin/hdfs dfs -mkdir -p /user/shardbuilder"
    su hdfs -c "/usr/bin/hdfs dfs -chown shardbuilder:imhotep /user/shardbuilder"
    su hdfs -c "/usr/bin/hdfs dfs -mkdir -p /user/root"
    su hdfs -c "/usr/bin/hdfs dfs -chown root:imhotep /user/root"

    su hdfs -c "/usr/bin/hdfs dfs -chgrp imhotep /"
    su hdfs -c "/usr/bin/hdfs dfs -chmod g+w /"

    echo "Creating /imhotep/ in HDFS"
    su hdfs -c "/usr/bin/hdfs dfs -mkdir /imhotep"
    su hdfs -c "/usr/bin/hdfs dfs -chown hdfs:imhotep /imhotep"
    /usr/bin/hdfs dfsadmin -refreshUserToGroupsMappings

    su tomcat7 -c "/usr/bin/hdfs dfs -mkdir -p /imhotep/imhotep-build/iupload/failed"
    su tomcat7 -c "/usr/bin/hdfs dfs -mkdir -p /imhotep/imhotep-build/iupload/indexedtsv"
    su tomcat7 -c "/usr/bin/hdfs dfs -mkdir -p /imhotep/imhotep-build/iupload/tsvtoindex"
    su shardbuilder -c "/usr/bin/hdfs dfs -mkdir -p /imhotep/imhotep-data"
fi

su hdfs -c "/usr/bin/hdfs dfs -find /"

if [ "$1" == "" ]; then
    while [ -true ]; do
        sleep 30
    done
else
    exec "$1"
fi
