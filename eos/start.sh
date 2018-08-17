#!/bin/sh
CurrentDIR=

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

mine= 

if [ "$1" = "mine" ]; then 
    mine='-e'
fi

# nodeos=/Users/cengliang/code/eos/build/programs/nodeos/nodeos
nodeos=nodeos

configerdir=$CurrentDIR/configer
datadir=$CurrentDIR/data/
genesis='--genesis-json /Users/cengliang/code/startup-chains/eos/configer/genesis.json'

$nodeos --config-dir $configerdir --data-dir $datadir $mine

# $nodeos --config-dir $configerdir --data-dir /Users/cengliang/code/startup-chains/eos/data --genesis-json /Users/cengliang/code/startup-chains/eos/configer/genesis.json
