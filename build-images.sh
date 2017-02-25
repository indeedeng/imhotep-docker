#!/bin/bash

set -e -u -o pipefail

cd "$(dirname $0)"

readonly prefix="local"

oslist=(
    centos6
)
images=(
    zookeeper
    cdh5-hdfs
    daemon
    frontend
)

docker pull centos:6

for os in "${oslist[@]}"; do
    for img in "${images[@]}"; do
        echo "build ${prefix}/imhotep-${img}:${os}"
        docker build -t "${prefix}/imhotep-${img}:${os}" "${img}/${os}"
    done
done
