#!/bin/sh
COUNTER=1
NAME=$1

while true
  do
    echo "------------------ $NAME Sending log to fluentD ------------------"
    curl -X POST -d 'json={"name":"'$NAME'", "counter":'$COUNTER'}' http://fluentd:9880/http-myapp.log
    let COUNTER++
    sleep 5
  done