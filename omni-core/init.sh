#!/bin/bash - 

set -o nounset                              # Treat unset variables as an error

echo mine 120 blocks--------------------------------------
./cli.sh generate 120
sleep 1s

echo import privatekey and addresses----------------------
./cli.sh importprivkey cTXommfMPSgbzBLF6165wMzF7Ch7LCLiCdMEJGDKvxXekxjMwd5Q "default"

./cli.sh importaddress n3aE47Usp7ZDBje5QvCj4gWtn1Wjh9iMv5 "watchonly_addresses"

./cli.sh importaddress n1qsiUPQTVCRmt2pKSEQpS44SF6tPYLr7H "watchonly_addresses"

./cli.sh sendtoaddress n3MoUv3MW87AJQ9SKzidEA8RHyUwhixw7t 20
./cli.sh sendtoaddress n3aE47Usp7ZDBje5QvCj4gWtn1Wjh9iMv5 0.000006
./cli.sh sendtoaddress n1qsiUPQTVCRmt2pKSEQpS44SF6tPYLr7H 10 

echo mine 2 blocks----------------------------------------
./cli.sh generate 2
sleep 1s

echo issure token 'ZToken'--------------------------------
./cli.sh omni_sendissuancefixed "n3MoUv3MW87AJQ9SKzidEA8RHyUwhixw7t" 2 2 0 "zl03jsj@163.com" "zl03jsj@163.com" "ZToken" "zl03jsj@163.com" "ZToken_divisible" "10000000"
./cli.sh generate 2
sleep 1s

echo send 100 token to n3aE47Usp7ZDBje5QvCj4gWtn1Wjh9iMv5--
./cli.sh omni_send n3MoUv3MW87AJQ9SKzidEA8RHyUwhixw7t n3aE47Usp7ZDBje5QvCj4gWtn1Wjh9iMv5 2147483651 100
./cli.sh generate 2
sleep 1s

echo init success, result ---------------------------------
blockheight=`./cli.sh getblockcount`
blockhash=`./cli.sh getblockhash $blockheight`
echo now blockheight=$blockheight blockhash=$blockhash

