#!/bin/bash - 

set -o nounset 

killwho=$1

if [  "$#" == "0" ]; then
    echo kill \'what\' is required, \'bitcoin\', \'bitcoin-sv\' ......
    exit
fi

if [ "x$killwho" == "x" ]; then
    echo kill \'what\' is required, \'bitcoin\', \'bitcoin-sv\' ......
    exit
fi

function get_psid() {
    echo `ps -ef | grep -v -E 'grep|.*kill.*\.sh' | grep $killwho | awk '{print $2}'`
}

psid=$(get_psid)

if [ "$psid" == "" ]; then
    echo didn\'t found any \'$killwho\'
    exit
fi

kill $psid
echo bitcoind-sv process: $psid is killed

