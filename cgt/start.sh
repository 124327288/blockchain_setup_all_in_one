#!/bin/bash
./geth --datadir ./data --rpc -rpcapi 'db,net,admin,miner,eth,web3,debug,personal' --rpccorsdomain "*" --syncmode "full" --rpcport 8100 --ws --wsaddr=127.0.0.1 --wsport 8500 --wsapi "db,personal,eth,net,web3,debug" --wsorigins "*"  console

