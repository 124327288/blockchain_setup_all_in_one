#!/bin/bash - 
set -o nounset                              # Treat unset variables as an error

killwho=$1

function get_psid() {
    echo `ps -ef | grep -v -E "grep|($$)|/bin/bash" | grep $killwho | awk '{print $2}'`
}

processid=$(get_psid)

