#!/bin/bash

function current_dir() {
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    echo $( cd -P "$( dirname "$SOURCE" )" && pwd )
}

function get_psid() {
    if [  "$#" == "0" ]; then
        echo ""
    fi
    echo `ps -ef|grep -v grep|grep bitcoin-sv|awk '{print $2}'`
}


current_dir=$(current_dir)

conffile=$current_dir/bsv.conf
dataDir=$current_dir/data/


if [ ! -d "$datadir" ]; then
    mkdir -p $dataDir
fi

psid=$(get_psid)

if [ "$psid" != "" ]; then 
    echo  bitocind  still runing, process id:$psid
    exit
fi

bitcoind=~/code/chain_src/bitcoin-sv/src/bitcoind
$bitcoind -conf=$conffile -deprecatedrpc=accounts -deprecatedrpc=generate -daemon

sleep 1s
psid=$(get_psid)
echo bitcoind process id: $psid
