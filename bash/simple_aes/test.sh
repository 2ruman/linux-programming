#!/bin/bash

PROG="simple_aes.sh"
ARW_UP=$'\U2191'
RED='\033[0;31m'
GRN='\033[0;32m'
YLW='\033[1;33m'
NOC='\033[0m'

noerr() {
    echo -e "${GRN}${ARW_UP} No error expected${NOC}\n"
}

expect() {
    echo -e "${RED}${ARW_UP} ${1}${NOC}\n"
}

do_test() {
    PROMPT=$@
    echo -e "Prompt: ${YLW}${PROMPT}${NOC}\nResult:"
    $PROMPT
}

check() {
    echo -e "Check:"
    cat $1
}

tear_down() {
    rm test_enc.txt
    rm test_dec.txt
}

echo "[ Test started ]"
echo

do_test $PROG
expect "Not enough arguments - error expected"


do_test $PROG -e
expect "Not enough arguments - error expected"

do_test $PROG -w test.txt
expect "Invalid option - error expected"

do_test $PROG -e not_exists.txt
expect "Invalid input file - error expected"

do_test $PROG -e test.txt test_enc.txt
check test_enc.txt
noerr

do_test $PROG -e test.txt test_enc.txt
expect "File already exists - expected but no error"

do_test $PROG -d test_enc.txt test_dec.txt
check test_dec.txt;
noerr

do_test $PROG -d test_enc.txt test_dec.txt
expect "File already exists - expected but no error"

do_test $PROG -d test_enc.txt
noerr

tear_down
echo "[ Test ended ]"
