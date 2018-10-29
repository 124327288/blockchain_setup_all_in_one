#!/bin/bash

function show_usage() {
    echo USAGE:
    echo    set_proxy.sh [arguments...]
    echo OPTIONS:
    echo '  '-a'    'application name, it can be 'git', 'console'
    echo '  '-e'    'to enable or disable proxy, [yes/true/1] for enable\; [no/false/0] for disable
    echo '  '-h'    'show help
    echo example:
    echo '  'set_proxy.sh -a git -e true'       'git proxy on
    echo '  'set_proxy.sh on'                   'git, console proxy on
    echo '  'set_proxy.sh off'                  'git, console proxy off
}

function enable_console() {
    export http_proxy=https://127.0.0.1:50361
    export https_proxy=https://127.0.0.1:50361
    echo enable console proxy success
}

function disable_console() {
    export http_proxy=
    export https_proxy=
    echo disable console proxy success
}

function enable_git() {
    git config --global http.proxy https://127.0.0.1:50361
    git config --global https.proxy https://127.0.0.1:50361
    echo enable git proxy success
}

function disable_git() {
    git config --global --unset http.proxy
    git config --global --unset https.proxy
    echo disable git proxy success
}

function enable_all() {
    enable_git
    enable_console

}

function disable_all() {
    disable_console
    disable_git
}

application=all
isenable=

while getopts "a:e:h" arg
do
    case $arg in
        a) application=$OPTARG ;;
        e) isenable=$OPTARG ;;
        h|?) show_usage; exit 0 ;;
    esac
done

if [ "$isenable" == "" ]; then
    isenable=$1
fi

if [ "$isenable" == "true" -o "$isenable" == "1" -o "$isenable" == "yes" -o "$isenable" == "on" ]; then
    case $application in 
        all) enable_all ;;
        console) enable_console ;;
        git) enable_git ;;
        *) echo application:$application unkown; show_usage ;;
    esac
else 
    case $application in 
        all) disable_all ;;
        console) disable_console ;;
        git) disable_git ;;
        *) echo application:$application unkown; show_usage ;;
    esac
fi




# TEMP=`getopt -o a::bc: --long arga::,argb,argc: -n 'test.sh' -- "$@"`
# eval set -- "$TEMP"
# 
# # extract options and their arguments into variables.
# while true ; do
#     case "$1" in
#         -a|--arga)
#             case "$2" in
#                 "") ARG_A='some default value' ; shift 2 ;;
#                 *) ARG_A=$2 ; shift 2 ;;
#             esac ;;
#         -b|--argb) ARG_B=1 ; shift ;;
#         -c|--argc)
#             case "$2" in
#                 "") shift 2 ;;
#                 *) ARG_C=$2 ; shift 2 ;;
#             esac ;;
#         --) shift ; break ;;
#         *) echo "Internal error!" ; exit 1 ;;
#     esac
# done
