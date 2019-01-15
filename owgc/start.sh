#!/bin/bash

data_dir=./data
if [ ! -d "$data_dir" ]; then
    mkdir -p $data_dir
fi

./geth-mac --owgc --datadir $data_dir --ipcdisable --ws --wsaddr "localhost" --wsport 8456 --wsapi db,personal,eth,net,web3,debug --wsorigins=* console

