#!/bin/bash

./shutdown.sh

function updateCurrentPath() {
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    CurrentDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
}

updateCurrentPath

datadir=$CurrentDIR/data
walletdir=/Users/cengliang/eosio-wallet

if [ -d "$datadir" ]; then
    rm -r $datadir
fi

if [ -d "$walletdir" ]; then
    rm -r $walletdir
fi
