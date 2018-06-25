#!/bin/bash

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

configerFile=$CurrentDIR/configer 
dataDir=$CurrentDIR/data/

echo configfile=$configerFile
echo datadir=$dataDir


if [ ! -d "$datadir" ]; then
    mkdir -p $dataDir
fi

omnicore-qt -conf=$configerFile -datadir=$dataDir -deprecatedrpc=accounts
