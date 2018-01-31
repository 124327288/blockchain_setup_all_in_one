#!/bin/bash

function help() {
    echo '------help------'
    echo 'start.sh help, show helps'
    echo 'start.sh mine, start 1 thread miner with coinbase:0x000....001'
    echo 'start.sh [2 number] example: start.sh 00'
}

if [ "$1" == "help" ]; then 
    help
    exit 0
fi

if [ ! -f bootnode.log ];then
    echo "please run bootnode.sh first"
    exit
fi

ip=$(ifconfig|grep inet|grep -v inet6|grep broadcast|awk '{print $2}')
bootnode_addr=enode://"$(grep enode bootnode.log|tail -n 1|awk -F '://' '{print $2}'|awk -F '@' '{print $1}')""@$ip:30301"



if [ "$1" == "" ];then
    echo "node id is empty, please use: start.sh <node_id>";
    exit
fi



no=$1
datadir=data
mkdir -p $datadir/$no
if [ ! -d "$DIRECTORY" ]; then
    if [ ! -f $datadir/genesis ];then
        password_file=$datadir/$no"/password.txt"

        echo ko2005,./123eth > $password_file
        geth --datadir=$datadir/$no --password $password_file account new > $datadir/$no"/account1.txt"
        geth --datadir=$datadir/$no --password $password_file account new > $datadir/$no"/account2.txt"

        address1=`awk  '{print $2}' $datadir/$no"/account1.txt"`
        address2=`awk  '{print $2}' $datadir/$no"/account2.txt"`

        address1=${address1:1:40}
        address2=${address2:1:40}
        echo account1=$address1
        echo account1=$address2

        echo '{"config": {"chainId": 15, "homesteadBlock": 0, "eip155Block": 0, "eip158Block": 0 }, "coinbase" : "0x0000000000000000000000000000000000000001", "difficulty" : "0x100000", "extraData" : "", "gasLimit" : "0xffffffff", "nonce" : "0x0000000000000042", "mixhash" : "0x0000000000000000000000000000000000000000000000000000000000000000", "parentHash" : "0x0000000000000000000000000000000000000000000000000000000000000000", "timestamp" : "0x00", "alloc": {"'$address1'":{"balance":"100000000000000000000000"}, "'$address2'":{"balance":"100000000000000000000000"} } }' > $datadir/genesis
    fi

    geth --datadir $datadir/$no init ./data/genesis 
fi

command=
if [ "mine" == "$no" ];then
    command='geth --datadir ./data/mine --networkid 10086 --ipcdisable --port 62000 --rpc --rpccorsdomain "*" --rpcport 8200 --bootnodes '$bootnode_addr' --mine --minerthreads=1 --etherbase=0x0000000000000000000000000000000000000001 console'
else
    command='geth --datadir ./data/'$no' --networkid 10086 --ipcdisable --port 619'$no' --rpc --rpccorsdomain "*" --rpcport 81'$no' --bootnodes '$bootnode_addr' console'
fi

echo '--------excute shell command:-----'
echo $command
echo '----------------------------------'

$command


