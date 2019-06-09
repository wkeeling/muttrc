#!/usr/bin/env bash
#set -x
IFS=$'\n'

tracer=0
nick=""
long=""
mail=""
for line in $(grep -Ev "^$|^#" "$1")
do
    verb=$(echo $line|cut -d ':' -f 1|cut -d ';' -f 1| tr -d '\r')
    case $verb in
    BEGIN)
        tracer=$((tracer + 1))
        ;;
    FN)
        long=$(echo $line|cut -d ':' -f 2| tr -d '\r')
        ;;
    EMAIL)
        mail=$(echo $line|cut -d ':' -f 2| tr -d '\r')
        nick=$(echo $mail|cut -d '@' -f 1| tr -d '\r')
        ;;
    END)
        tracer=$((tracer + 1))
        ;;
    esac

    if [ $tracer -eq 2 ]
    then
        echo "alias $nick $long $mail"
        tracer=0
        nick=""
        long=""
        mail=""
    fi
done
