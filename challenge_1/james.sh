#!/bin/bash

# roman.sh
# Description: Roman number calculator.
# Takes input from a file or standard in
# author: jamesp@teamddm.com
# date: 2012-07-25

FILE=$1
STIN=0

if [ ! -f $FILE ]
then
    echo $1 > /tmp/roman.txt
    FILE="/tmp/roman.txt"
    STIN=1
fi

while read line
do
        if [ -z "$line" ]
        then
            echo -e "\033[37;41mEmpty line\033[0m"
            continue
        fi

        TOTAL=0
        VALID=1
        lastlookup='0'
        v=0
        text=$(echo $line | awk -F' ' '{ print $1 }')
        for ((i = 0; i < ${#text}; i++))
        do
            char=${text:$i:1}

            case "$char" in
                I) TOTAL=$(echo "$TOTAL + 1" | bc); v=1 ;;
                V) TOTAL=$(echo "$TOTAL + 5" | bc); v=5 ;;
                X) TOTAL=$(echo "$TOTAL + 10" | bc); v=10 ;;
                L) TOTAL=$(echo "$TOTAL + 50" | bc); v=50 ;;
                C) TOTAL=$(echo "$TOTAL + 100" | bc); v=100 ;;
                D) TOTAL=$(echo "$TOTAL + 500" | bc); v=500 ;;
                M) TOTAL=$(echo "$TOTAL + 1000" | bc); v=1000 ;;
                *) VALID=0
                    break;
            esac

            if [ "$v" -gt "$lastlookup" -a "$lastlookup" -gt "0" ]
            then
                TOTAL=$(echo "($TOTAL - $lastlookup - $lastlookup)" | bc)
            else
                lastlookup=$v
            fi
        done

        if [ $VALID == "1" ]
        then
            if [ $STIN == 0 ]
            then
                echo -e "$text=$TOTAL";
            else
                echo -e "$TOTAL";
            fi
        else
            echo -e "\033[37;41mInvalid sequence: $line\033[0m";
        fi
done < "$FILE"
