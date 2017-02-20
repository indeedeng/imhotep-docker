#!/bin/sh

service crond start
service httpd start
service tomcat start

while [ -true ]; do
    sleep 30
done
