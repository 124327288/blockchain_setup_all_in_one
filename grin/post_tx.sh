#!/bin/bash - 

port="$1"

if [ "$port" == "" ]; then
    echo error : port is requried, default:3420, customize:4420
    exit -1
fi

data=`cat ./result.issue_send_tx`;

result=`curl -0 -XPOST http://127.0.0.1:"$port"/v1/wallet/owner/post_tx?fluff -d "$data"`

echo -------------------------------------
echo $result
echo -------------------------------------

echo $result > result.post_tx

