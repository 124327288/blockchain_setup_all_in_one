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
    echo `ps -ef|grep -v grep|grep zcashd|awk '{print $2}'`
}


current_dir=$(current_dir)

configerfile=$current_dir/zcash.conf
dataDir=$current_dir/data/


if [ ! -d "$datadir" ]; then
    mkdir -p $dataDir
fi

psid=$(get_psid)

if [ "$psid" != "" ]; then 
    echo zcashd still runing, process id:$psid
    exit
fi

zcash=~/code/chain_src/zcash-apple/out/usr/local/bin/zcashd

# activate overwinter
#$zcash -conf=$configerfile -datadir=$dataDir -nuparams=5ba81b19:101 -daemon
#activate sapling 
$zcash -conf=$configerfile -datadir=$dataDir -nuparams=5ba81b19:101 -nuparams=76b809bb:120 -daemon

sleep 1s
psid=$(get_psid)
echo zcash process id: $psid
