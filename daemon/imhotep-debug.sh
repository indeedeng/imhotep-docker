#!/bin/bash

export CLASSPATH="/opt/imhotep:/opt/imhotep/imhotep-server/lib/*:"$CLASSPATH

java -Xmx5G -Dlog4j.configuration=file:///opt/imhotep/log4j.xml -Djava.io.tmpdir=/var/data/imhotep/tmp -Dcom.indeed.flamdex.simple.useNative=true -Dcom.indeed.flamdex.simple.useSSSE3=true -agentlib:jdwp=transport=dt_socket,address=localhost:9009,server=y,suspend=y com.indeed.imhotep.service.ImhotepDaemon /user/root/imhotep-data /var/tempFS --port 12345 --memory $((5 * 1024 - 512)) --zknodes localhost:2181 --zkpath /imhotep/daemons --lazyLoadProps /opt/imhotep/imhotep-caching.yaml
