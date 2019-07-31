#!/bin/bash - 

set -o nounset 

if [  "$#" != "1" ]; then
    echo kill \'what\' is required, \'bitcoin\', \'bitcoin-sv\' ......
    exit
fi

killwho=$1

if [ "x$killwho" == "x" ]; then
    echo kill \'what\' is required, \'bitcoin\', \'bitcoin-sv\' ......
    exit
fi

source ./get_processid.sh $killwho

if [ "$processid" == "" ]; then
    echo didn\'t found any \'$killwho\'
    exit
fi

kill $processid
echo process $killwho:$processid is successly killed.

