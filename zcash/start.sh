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

current_dir=$(current_dir)

configerfile=$current_dir/zcash.conf
dataDir=$current_dir/data/


if [ ! -d "$datadir" ]; then
    mkdir -p $dataDir
fi

zcash=~/code/chain_src/zcash-apple/out/usr/local/bin/zcashd
$zcash -conf=$configerfile -datadir=$dataDir
