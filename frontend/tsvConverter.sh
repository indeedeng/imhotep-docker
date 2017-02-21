#!/bin/bash

lockfile -r 0 /tmp/tsvConverter.lock || exit 1

export CLASSPATH="/opt/imhotepTsvConverter/shardBuilder/lib/*:/opt/imhotepTsvConverter/conf:"$CLASSPATH

BUILD=/imhotep/imhotep-build
DATA=/imhotep/imhotep-data

java -Xmx20G com.indeed.imhotep.builder.tsv.TsvConverter --index-loc $BUILD/iupload/tsvtoindex --success-loc $BUILD/iupload/indexedtsv --failure-loc $BUILD/iupload/failed --data-loc $DATA/ --build-loc /var/data/build

# Remove the lockfile
rm -f /tmp/tsvConverter.lock
