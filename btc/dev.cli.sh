#!/bin/bash

~/code/chain_src/bitcoin/src/bitcoin-cli --rpcconnect=18.212.119.3 --rpcport=18443 --rpcuser=zengl --rpcpassword=123456 "$@"

#curl --user zengl:123456 --data-binary '{"jsonrpc": "1.0", "id":"curltest", "method": "generate", "params": [1] }' -H 'content-type: text/plain;' http://18.212.119.3:18443/
