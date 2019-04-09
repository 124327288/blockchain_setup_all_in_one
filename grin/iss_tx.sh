#!/bin/bash - 

port="$1"

if [ "$port" == "" ]; then
    echo error : port is requried, default:3420, customize:4420
    exit -1
fi

# 1 grin:1000000000
data=`cat ./issue_send_tx-01.json`; 

echo tx detail:
echo $data

result=`curl -0 -XPOST http://127.0.0.1:"$port"/v1/wallet/owner/issue_send_tx -d "$data"`

echo -------------------------------------
echo $result
echo -------------------------------------

echo $result > result.issue_send_tx

