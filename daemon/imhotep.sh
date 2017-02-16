#!/bin/bash

export CLASSPATH="/opt/imhotep/imhotep-server/lib/*:"$CLASSPATH

java -Xmx5G -Dlog4j.configuration=file:///opt/imhotep/log4j.xml -Djava.io.tmpdir=/var/data/imhotep/tmp -Dcom.indeed.flamdex.simple.useNative=true -Dcom.indeed.flamdex.simple.useSSSE3=true com.indeed.imhotep.service.ImhotepDaemon /var/data/indexes/ /var/tempFS --port 12345 --memory $((5 * 1024 - 512)) --zknodes localhost:2181 --zkpath /imhotep/daemons --lazyLoadProps /opt/imhotep/imhotep-caching.yaml
