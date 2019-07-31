#!/bin/bash - 

set -o nounset 

pidfile=./data/regtest/bitcoind.pid

if [ ! -f $pidfile ]; then
    echo processid file not exist:$pidfile
    echo -------------------------------------
    echo try find process by name:'bitcoin-sv', and kill...
    cd ../
    source ./kill.sh bitcoin-sv
else
    echo bitcoin prcocessfile exist:$pidfile
    processid=`cat $pidfile`

    kill $processid

    echo kill bitcoin process\($processid\) success
fi


