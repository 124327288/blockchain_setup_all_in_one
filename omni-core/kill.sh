#!/bin/bash

function get_psid() {
    if [  "$#" == "0" ]; then
        echo ""
    fi
    echo `ps -ef|grep -v grep|grep $1|awk '{print $2}'`
}

psid=$(get_psid "omnicore-qt")

if [ "$psid" != "" ]; then
    kill $psid
    echo bitcoind process: $psid is killed
fi

psid=$(get_psid("omnicored"))

if [ "$psid" != "" ]; then
    kill $psid
fi

