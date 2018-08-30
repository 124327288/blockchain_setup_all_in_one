#!/bin/bash

echo ---------------create 'default' wallet---------------

wallet=$1

if [ "$wallet" == "" ]; then 
    wallet="default"
fi

password=`$(echo "cleos wallet create -n $wallet" --to-console)`
password=${password%\"*}
password=${password##*\"}

echo _________________________________________
echo '|' wallet name: [$wallet]
echo '|' wallet password: [$password]
echo -----------------------------------------

if [ "$password" = "" ]; then 
    echo "password is nil, exception happend, exit"
    exit
fi


## ${varible##*string}   从左向右截取最后一个string后的字符串
## ${varible#*string}    从左向右截取第一个string后的字符串
## ${varible%%string*}   从右向左截取最后一个string后的字符串
## ${varible%string*}    从右向左截取第一个string后的字符串 

owner_pri_key=5J7TUTnvVmZ6CKUonh8j6LcAdQXM45T9NHo4mDHNrnug56xdGw4
owner_pub_key=EOS7e71rLRrUyQJZGod4KTBQH7YBpXua4beXE8d3eVvJPskYxvd5g
active_pri_key=5Jv6oEHbkViuSRqtorffQKRZT9yoYeK4kxTneqafWWd6fA7WH4L
active_pub_key=EOS7ApfF3yYDfqyxV1hsoWpux5Jj6gAQdm6BnqwK3zM5rLDJ2xSCq


echo ---------------unlock wallet: $wallet---------------
cleos wallet unlock -n $wallet --password $password

echo ---------------import keys---------------
cleos wallet import --private-key $owner_pri_key  -n $wallet
cleos wallet import --private-key $active_pri_key -n $wallet
cleos wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3 -n $wallet

#echo ---------------set eosio contract 'eosio.system'---------------
#contractdir=/Users/cengliang/code/eos/build/contracts/eosio.system
#wasmfile=eosio.system.wasm
#abifile=eosio.system.abi
#cleos set contract eosio $contractdir $wasmfile $abifile
#
#
#echo 

sleep 1s
echo ---------------create account 'eosio.token'---------------
cleos create account eosio eosio.token $owner_pub_key $active_pub_key --permission eosio@active
sleep 1s
cleos create account eosio user.1      $owner_pub_key $active_pub_key --permission eosio@active
sleep 1s
cleos create account eosio user.2      $owner_pub_key $active_pub_key --permission eosio@active

echo

sleep 1s
echo ------------------------------------------------------
cleos get account eosio.token --json
echo

echo ---------------create token with 'eosio.token'---------------
contractdir=/Users/cengliang/code/eos/build/contracts/eosio.token
wasmfile=eosio.token.wasm
abifile=eosio.token.abi
cleos set contract eosio.token $contractdir $wasmfile $abifile
echo

sleep 1s
echo -------------------------eosio.token token code hash-------------------------
echo cleos get code eosio.token
cleos get code eosio.token
echo

echo -------------------------create token 'EOS'-------------------------

#cleos push action eosio.token create '["eosio","1000000000.0000 EOS",0,0,0]' -p eosio.token
cleos push action eosio.token create '{"issuer":"eosio.token","maximum_supply":"1000000.0000 EOS","can_freeze":"0","can_recall":"0","can_whitelist":"0"}' --permission eosio.token
echo

sleep 1s
echo ---------------issure token 'EOS'---------------
cleos push action eosio.token issue '{"to":"eosio","quantity":"1000000.0000 EOS","memo":""}' --permission eosio.token
echo

sleep 1s
echo ---------------show eosio.token balance---------------
cleos get table eosio.token eosio.token accounts
echo

echo ---------------send token from 'eosio.token' to 'eosio'---------------
cleos push action eosio.token transfer '{"from":"eosio","to":"eosio.token","quantity":"20.0000 EOS","memo":"my first transfer"}' --permission eosio
echo

cleos push action eosio.token transfer '{"from":"eosio","to":"user.1","quantity":"20.0000 EOS","memo":"send 20 to user.1"}' --permission eosio
cleos push action eosio.token transfer '{"from":"eosio","to":"user.2","quantity":"20.0000 EOS","memo":"send 20 to user.2"}' --permission eosio

echo ---------------show eosio balance---------------
cleos get table eosio.token eosio accounts


echo ---------------show user.1 actions---------------
cleos get actions user.1 0 10
echo ---------------show user.2 actions---------------
cleos get actions user.2 0 10
