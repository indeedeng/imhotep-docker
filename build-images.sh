#!/bin/bash

set -e -u -o pipefail

cd "$(dirname $0)"

readonly prefix="local"

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

jdkfn=`grep "COPY ./jdk" base-java7/centos6/Dockerfile | cut -f2 -d/ | cut -f1 -d\ `
if [[ -f base-java7/$jdkfn ]]; then
    echo $jdkfn found
    for os in "${oslist[@]}"; do
        cp base-java7/$jdkfn base-java7/$os/
    done
else
    echo "ERROR: You must download $jdkfn and copy into base-java7/"
    exit 1
fi

echo "Running with DOCKER_BUILD_OPTS=${DOCKER_BUILD_OPTS:=}"

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
