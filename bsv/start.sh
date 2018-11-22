#!/bin/bash

function get_current_dir() {
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    echo "$( cd -P "$( dirname "$SOURCE" )" && pwd )"
}

current_dir=$(get_current_dir)
config_file=$current_dir/bsv.conf
data_dir=$current_dir/data/

if [ ! -d "$data_dir" ]; then
    mkdir -p $data_dir
fi

~/code/chain_src/bitcoin-sv/src/bitcoind -conf=$config_file -datadir=$data_dir
