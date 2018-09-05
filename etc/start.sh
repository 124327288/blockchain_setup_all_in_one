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
    echo "please run bootnode.sh first"
    exit
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

if [ ! -d "$datadir/$no" ]; then 
    mkdir -p $datadir/$no
fi

function chainJSON () {
    echo '{ "identity": "privnet", "name": "private Net", "state": { "startingNonce": 1048576 }, "network": 15, "consensus": "ethash", "genesis": { "nonce": "0x00006d6f7264656e", "timestamp": "", "parentHash": "", "extraData": "", "gasLimit": "0x2FEFD8", "difficulty": "0x010000", "mixhash": "0x00000000000000000000000000000000000000647572616c65787365646c6578", "coinbase": "0x0000000000000000000000000000000000000001", "alloc": { "0000000000000000000000000000000000000001": { "balance": "1" }, "2e9f167f1c7c187ba214daa7c09f04c33f157bc8": { "balance": "100000000000000000000000" }, "abf526ef9accd84481127c5e1ee807ecb8155b6d": { "balance": "100000000000000000000000" } }, "alloc_file": "" }, "chainConfig": { "forks": [ { "name": "Homestead", "block": 494000, "requiredHash": "0x0000000000000000000000000000000000000000000000000000000000000000", "features": [ { "id": "difficulty", "options": { "type": "homestead" } }, { "id": "gastable", "options": { "type": "homestead" } } ] }, { "name": "GasReprice", "block": 1783000, "requiredHash": "0x0000000000000000000000000000000000000000000000000000000000000000", "features": [ { "id": "gastable", "options": { "type": "eip150" } } ] }, { "name": "The DAO Hard Fork", "block": 1885000, "requiredHash": "0x0000000000000000000000000000000000000000000000000000000000000000", "features": [ ] }, { "name": "Diehard", "block": 1915000, "requiredHash": "0x0000000000000000000000000000000000000000000000000000000000000000", "features": [ { "id": "eip155", "options": { "chainID": 15 } }, { "id": "gastable", "options": { "type": "eip160" } }, { "id": "difficulty", "options": { "length": 2000000, "type": "ecip1010" } } ] }, { "name": "Gotham", "block": 2000000, "requiredHash": "0x0000000000000000000000000000000000000000000000000000000000000000", "features": [ { "id": "reward", "options": { "era": 2000000, "type": "ecip1017" } } ] }, { "name": "Defuse Difficulty Bomb", "block": 2300000, "requiredHash": "0x0000000000000000000000000000000000000000000000000000000000000000", "features": [ { "id": "difficulty", "options": { "type": "defused" } } ] } ], "badHashes": [ { "Block": 383792, "Hash": "0x9690db54968a760704d99b8118bf79d565711669cefad24b51b5b1013d827808" }, { "Block": 1915277, "Hash": "0x3bef9997340acebc85b84948d849ceeff74384ddf512a20676d424e972a3c3c4" } ] }, "bootstrap": [ ], "include": null }'
}

if [ ! -f "$datadir/$no/privnet/chain.json" ]; then
    password_file=$datadir/$no"/password.txt"

    echo ko2005,./123eth > $password_file
    geth --datadir=$datadir/$no --chain privnet --password $password_file account new > $datadir/$no"/account1.txt"
    geth --datadir=$datadir/$no --chain privnet --password $password_file account new > $datadir/$no"/account2.txt"

    address1=`awk  '{print $2}' $datadir/$no"/account1.txt"`
    address2=`awk  '{print $2}' $datadir/$no"/account2.txt"`

    address1=${address1:1:40}
    address2=${address2:1:40}
    echo account1=$address1
    echo account1=$address2

    echo $(chainJSON) > $datadir/$no/privnet/chain.json
fi

command=
if [ "mine" == "$no" ];then
    command='geth --datadir ./data/mine --chain privnet --verbosity 6 --networkid 10086 --ipcdisable --port 619'$no' --ws --wsaddr=localhost --wsport 85'$no' --wsapi "db,personal,eth,net,web3,debug" --wsorigins=* --bootnodes '$bootnode_addr' console'

elif [ "remix" == "$no" ];then
    geth --datadir ./data/00 --chain privnet --verbosity 6 --networkid 10086 --rpc --rpcapi 'db,net,admin,miner,eth,web3,debug,personal' --rpcport 8545 --rpccorsdomain '*' --ws --wsaddr=localhost --wsport 8500 --wsapi "db,personal,eth,net,web3,debug" --wsorigins=* --etherbase=0x0000000000000000000000000000000000000001 console

else
    command='geth --datadir ./data/'$no' --chain privnet --verbosity 6 --networkid 10086 --ipcdisable --port 619'$no' --rpc -rpcapi 'db,net,admin,miner,eth,web3,debug,personal' --rpccorsdomain "*" --rpcport 81'$no' --ws --wsaddr=127.0.0.1 --wsport 85'$no' --wsapi "db,personal,eth,net,web3,debug" --wsorigins=* --bootnodes '$bootnode_addr' console'
fi

echo --------excute shell command:-----
echo $command
echo ----------------------------------

sleep 3s

$command


