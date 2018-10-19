#!/bin/bash

function get_psid() {
    if [  "$#" == "0" ]; then
        echo ""
    fi
    echo `ps -ef|grep -v grep|grep zcashd|awk '{print $2}'`
}

psid=$(get_psid)
if [ "$psid" == "" ]; then
    exit
fi

kill $psid
echo zcash process: $psid is killed

