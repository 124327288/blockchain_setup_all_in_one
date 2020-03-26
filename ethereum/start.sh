#!/bin/bash

function help() {
    echo '------help------'
    echo './start.sh help, show helps'
    echo './start.sh mine, start 1 thread miner with coinbase:0x000....001'
    echo '  this will not mine automatically, you should use: miner.start()'
    echo './start.sh [2 number] example: start.sh 00'
    echo './strat.sh remix start eth nodde as remix web3 provider'
}

if [ "$1" == "help" ]; then 
    help
    exit 0
fi

if [ ! -f bootnode.log ];then
    ./bootnode.sh
    sleep 1s
fi

ip=$(ifconfig|grep inet|grep -v inet6|grep broadcast|awk '{print $2}')
if [ "$ip" == "" ]; then
    ip=127.0.0.1
fi
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

        address1=`awk  '{print $6}' $datadir/$no"/account1.txt"`
        address2=`awk  '{print $6}' $datadir/$no"/account2.txt"`

        address1=${address1:3:42}
        address2=${address2:3:42}

        echo '{ "config": { "chainId": 15, "homesteadBlock": 0, "eip150Block": 0, "eip155Block": 0, "eip158Block": 0, "byzantiumBlock": 0, "constantinopleBlock": 0, "petersburgBlock": 0 }, "alloc": { "'$address1'": { "balance": "10000000000000000000000000" }, "'$address2'": { "balance": "10000000000000000000000000" } }, "coinbase": "0x0000000000000000000000000000000000000000", "difficulty": "0x1000", "extraData": "", "gasLimit": "0x2fefd8", "nonce": "0x0000000000000042", "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000", "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000", "timestamp": "0x00" }' > $datadir/genesis
    fi

    geth --datadir $datadir/$no init ./data/genesis 
fi

#--wsaddr value    WS-RPC server listening interface (default: "localhost")
#--wsport value    WS-RPC server listening port (default: 8546)
#--wsapi value     API's offered over the WS-RPC interface (default: "eth,net,web3")
#--wsorigins value Origins from which to accept websockets requests

command=
echo ›››››››››››$no
if [ "mine" == "$no" ];then
    command='geth --datadir ./data/mine --networkid 10086 --ipcdisable --port 619'$no' --ws --wsaddr=localhost --wsport 85'$no' --wsapi "db,personal,eth,net,web3,debug" --wsorigins=* --bootnodes '$bootnode_addr' console'

elif [ "remix" == "$no" ];then
    command='geth --datadir ./data/00 --rpc --rpcapi 'db,net,admin,miner,eth,web3,debug,personal' --rpcport 8545 --rpccorsdomain '*' --ws --wsaddr=localhost --wsport 8500 --wsapi "db,personal,eth,net,web3,debug" --wsorigins=* --etherbase=0x0000000000000000000000000000000000000001 console'
else
    command='geth --datadir ./data/'$no' --networkid 10086 --ipcdisable --port 619'$no' --rpc --rpcapi 'db,net,admin,miner,eth,web3,debug,personal,txpool' --allow-insecure-unlock --rpccorsdomain=* --rpcport 81'$no' --ws --wsaddr=127.0.0.1 --wsport 85'$no' --wsapi 'personal,eth,net,web3,miner,txpool,admin,debug,txpool' --wsorigins=* --bootnodes '$bootnode_addr' console'
fi

echo '--------excute shell command:-----'
echo $command
echo '----------------------------------'

$command

