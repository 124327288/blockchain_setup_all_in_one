#!/bin/bash

TEMP=`getopt -o a --long mine,test-net,newchain \
     -n 'example.bash' -- "$*"`

if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi

echo $TEMP
eval set -- "$TEMP"

options=
genesis_file=genesis.json
config_file=config.ini

while true ; do
    case "$1" in
        --mine) options="$options -e" ; shift ;;
        --newchain) options="$options --delete-all-blocks" ; shift ;;
        --test-net)
            genesis_file=genesis_jungletestnet.json
            config_file=config_jungletestnet.ini
            shift;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done


echo $options
echo $genesis_file
echo $config_file
