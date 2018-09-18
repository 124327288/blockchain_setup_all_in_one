#!/bin/bash
zcash_cli=~/code/chain_src/zcash-apple/out/usr/local/bin/zcash-cli

function current_dir() {
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    echo $( cd -P "$( dirname "$SOURCE" )" && pwd )
}

current_dir=$(current_dir)
configfile=zcash.conf
datadir=$current_dir

$zcash_cli -conf=$configfile -datadir=$datadir "$@"
