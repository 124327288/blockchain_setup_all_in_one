#!/bin/bash

pid=`ps -ef | grep nodeos | grep -v grep | awk '{print $2}'`
if [ "$pid" != "" ]; then
    kill -9 $pid
fi

pid=`ps -ef | grep keosd | grep -v grep | awk '{print $2}'`
if [ "$pid" != "" ]; then
    kill -9 $pid
fi

