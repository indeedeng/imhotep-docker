#!/bin/sh
# Builds the docker image for imhotep zookeeper and runs it in the background with the zookeeper port bound to the host
# Provided as an example

docker build -t imhotep-zookeeper .

docker run -d -p 2181:2181 imhotep-zookeeper

docker ps
