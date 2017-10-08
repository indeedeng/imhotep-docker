#!/bin/bash

set -e -u -o pipefail

cd "$(dirname $0)"

readonly prefix="local"

jdkfn=`grep "ADD ../jdk" base-java7/centos6/Dockerfile | cut -f2 -d/`
stat --printf='' base-java/$jdkfn 2>/dev/null
if [[ $? -ne 0 ]]; then
    echo "ERROR: You must download $jdkfn and copy into base-java/"
    exit 1
fi

echo "Running with DOCKER_BUILD_OPTS=${DOCKER_BUILD_OPTS:=}"

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
sed -i "s/latest/centos6/" docker-compose.yml
