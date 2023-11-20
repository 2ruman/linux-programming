#!/bin/bash

DEFAULT_OPT="t"
CNT=1
MAX_CNT=10000

getopts ":ti" OPT
case $OPT in
    t) ;; i) ;; *) OPT=$DEFAULT_OPT ;;
esac

if [ $OPT = "t" ]; then
    FN=$(date +log_%y%m%d_%H%M%S.txt)
else
    while : ; do
        FN="log_${CNT}.txt"
        [ ! -e $FN ] && break
        [ $((CNT++)) -ge $MAX_CNT ] && FN="" && break
    done
fi

echo $FN
