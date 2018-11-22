#!/bin/bash

bitcoin_cli=~/code/chain_src/bitcoin-sv/src/bitcoin-cli
current_dir=`./current_dir.sh`
config_file=$current_dir/bsv.conf
data_dir=$current_dir/data/

$bitcoin_cli -conf=$config_file -datadir=$data_dir "$@"
