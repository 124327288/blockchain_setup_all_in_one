#!/bin/bash

pidfile=./data/regtest/bitcoind.pid

if [ ! -f $pidfile ]; then
    echo processid file not exist:$pidfile
    echo -------------------------------------
    echo try find process by name:'bitcoind', and kill...
    cd ../
    source ./kill.sh bitcoin-sv
else
    echo bitcoin prcocessfile exist:$pidfile
    processid=`cat $pidfile`

    kill $processid

    echo kill bitcoin process\($processid\) success
fi

exit 0

cd ../
source ./kill.sh bitcoind

