ip=$(ifconfig|grep inet|grep -v inet6|grep broadcast|awk '{print $2}')
bootnode_addr=enode://"$(grep enode bootnode.log|tail -n 1|awk -F '://' '{print $2}'|awk -F '@' '{print $1}')""@$ip:30301"

echo bootnode=$bootnode_addr

command='geth --datadir ./data/mine --networkid 10086 --ipcdisable --port 62000 --rpc --rpccorsdomain "*" --rpcport 8200 --bootnodes '$bootnode_addr' --mine --minerthreads=1 --etherbase=0x0000000000000000000000000000000000000001 console'

echo '--------excute shell command:-----'
echo $command
echo '----------------------------------'

$command
