#!/bin/sh

nistTime=$(curl -sI https://api.myxl.xlaxiata.co.id | grep -i "^date:")

[ -z "$nistTime" ] && exit 1

dateValue=$(echo $nistTime | cut -d' ' -f3)
monthValue=$(echo $nistTime | cut -d' ' -f4)
yearValue=$(echo $nistTime | cut -d' ' -f5)
timeValue=$(echo $nistTime | cut -d' ' -f6)

case $monthValue in
 Jan) monthValue=01 ;;
 Feb) monthValue=02 ;;
 Mar) monthValue=03 ;;
 Apr) monthValue=04 ;;
 May) monthValue=05 ;;
 Jun) monthValue=06 ;;
 Jul) monthValue=07 ;;
 Aug) monthValue=08 ;;
 Sep) monthValue=09 ;;
 Oct) monthValue=10 ;;
 Nov) monthValue=11 ;;
 Dec) monthValue=12 ;;
 *) exit 1 ;;
esac

date -u -s "$yearValue-$monthValue-$dateValue $timeValue"
