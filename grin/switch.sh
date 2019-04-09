#!/bin/bash - 
set -o nounset                              # Treat unset variables as an error

dest="$1"

if [ "$dest" != "customize" ] && [ "$dest" != "default" ]; then
    echo require 'customize' or 'default' ... exit...
    exit
fi

if [ -f "/Users/cengliang/.grin/user/grin-wallet.toml" ]; then
    rm ~/.grin/user/grin-wallet.toml
fi

cp ~/.grin/user/grin-wallet.toml."$dest" ~/.grin/user/grin-wallet.toml

if [ $? -eq 0 ]; then
    echo switch to "$dest" succes..

    if [ -f "./___customize_is_activated__" ]; then 
        rm ./___customize_is_activated__
    fi

    if [ -f "./___default_is_activated__" ]; then 
        rm ./___default_is_activated__
    fi

    touch ___"$dest"_is_activated__
else
    echo switch to "$dest" faild...
    exit 1
fi
