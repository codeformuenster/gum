#!/bin/bash

PARAMS_CACHE=""
GUM="./gum -addr 0.0.0.0:8002"
pidfile="gum.pid"

while :
do
  # fetch redirects and transform for use with gum
  NOW=`date +%s`
  CURL_RES=`curl -s $URL?$NOW | sed -e 's/^/-redirect /' | tr '\n' ' '`
  # if the fetched content differs from the cache..
  if [ "$PARAMS_CACHE" != "$CURL_RES" ]
  then
    # if gum is currently running..
    if [ -e "$pidfile" ]
    then
      # kill it
      pid2kill=`cat $pidfile`
      kill -9 $pid2kill
      rm $pidfile
    fi
    # run it!
    exec $GUM $CURL_RES &
    # and write its pid to the pidfile
    PID=$!
    echo $PID > "$pidfile"
    PARAMS_CACHE=$CURL_RES
  fi
  # sleep ;)
  sleep 1m
done
