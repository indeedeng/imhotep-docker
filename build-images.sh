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
pids=

docker pull centos:6

for os in "${oslist[@]}"; do
    echo "build ${prefix}/imhotep-base-java7:${os}..."
    docker build $DOCKER_BUILD_OPTS -q -t "${prefix}/imhotep-base-java7:${os}" base-java7/${os}
    for img in "${images[@]}"; do
        echo "build ${prefix}/imhotep-${img}:${os}..."
        docker build $DOCKER_BUILD_OPTS -q -t "${prefix}/imhotep-${img}:${os}" "${img}/${os}" &
        pid=$!
        if [[ "$pids" == "" ]]; then
            pids=( "$pid" )
        else
            pids=( "${pids[@]}" "$pid" )
        fi
    done
done

wait "${pids[@]}"

docker images --filter "dangling=false" local/imhotep*

echo
echo "Changing indeedoss/ to local/ in docker-compose.yml"
sed -i "s/indeedoss/local/" docker-compose.yml
