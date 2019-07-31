#!/bin/bash - 
set -o nounset                              # Treat unset variables as an error

if [  "$#" != "1" ]; then
    echo one argument\'process name\' is required
    exit
elif [ "x$1" == "x" ]; then
    echo process name is empty
    exit
fi

psname=$1

function get_psid() {
    echo `ps -ef | grep -v -E "grep|($$)|/bin/bash" | grep $psname | awk '{print $2}'`
}

processid=$(get_psid)

