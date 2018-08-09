CurrentDIR=

function updateCurrentPath() {
    SOURCE="${BASH_SOURCE[0]}"
    while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
        DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
        SOURCE="$(readlink "$SOURCE")"
        [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
    done
    CurrentDIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
}

updateCurrentPath

mine= 

if [ "$1" = "mine" ]; then 
    mine='-e'
fi

# nodeos=/Users/cengliang/code/eos/build/programs/nodeos/nodeos
nodeos=nodeos
configerdir=$CurrentDIR/configer
datadir=$CurrentDIR/node-00
genesisfile=$configerdir/genesis.json


# if [ ! -d "$datadir" ]; then
#     mkdir -p $datadir
# fi

$nodeos --config-dir $configerdir --data-dir $datadir --filter-on eosio:transfer: $mine 

#$nodeos --config-dir $configerdir  --config $configerdir/config.ini --genesis-json ./configer/genesis.json -d $datadir -e -p eosio.zl

# $nodeos -e -p eosio --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin
