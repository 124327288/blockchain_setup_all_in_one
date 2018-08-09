#!/bin/bash
echo "***************************"
echo "Close the progress by name!"
echo "eg: ./close_p.sh progressName"
echo "***************************"
echo

#echo "PID of this script: $$"
#echo "PPID of this script: $PPID"

function MsgShow()
{
    if [ $# -lt 1 ] ; then
        echo "Parm err ! Exit the shell !";
        exit 1;
    else
        case ${1} in
            PARMMISS)
                echo "Missing process name to close!"
                ;;
            NOPROSS)
                echo "No such process[$2]!"
                ;;
            MULTIPROSS)
                echo "There are too many process contains name[$2]"
                ;;
            *)
                echo "Default case!"
                ;;
        esac
        exit 1;
    fi
}

function PidFind()
{
    PIDCOUNT=`ps -ef | grep $1 | grep -v "grep" | grep -v $0 | awk '{print $2}' | wc -l`;
    if [ ${PIDCOUNT} -gt 1 ] ; then
        MsgShow MULTIPROSS $1;
    elif [ ${PIDCOUNT} -le 0 ] ; then
        MsgShow NOPROSS $1;
    else
        PID=`ps -ef | grep $1 | grep -v "grep" | grep -v ".sh" | awk '{print $2}'` ;
        echo "Find the PID of this progress!--- process:$1 PID=[${PID}] ";
    fi
    read -p "Are you sure you want to close this progress[y/n]: "
    if [ $REPLY = "y" ] || [ $REPLY = "yes" ] ; then
        echo "Kill the process $1 ...";
        kill -9 ${PID};
        echo "kill -9 ${PID} done!";
    else
        echo "Confirmation of canceling,exit!";
        exit 1
    fi
    #if we use return ,the return val must between 0 and 255
}


if [ $# -lt 1 ] ; then
    MsgShow PARMMISS;
else
    PidFind $1;
fi
