#!/bin/bash - 
set -o nounset                              # Treat unset variables as an error

while true ; do
    blockhash=`./cli.sh generate 1|cut -c 3-68`
    blockheight=`./cli.sh getblockcount`
    echo new block, blockhash=$blockhash, blockheight=$blockheight
    sleep 5s
done
