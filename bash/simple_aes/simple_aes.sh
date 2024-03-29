#!/bin/bash

CIPHER="-aes-128-cbc"
ENCODING="-base64 -A" # Base64 enc/decoding + Single line
ADDITONAL_HASH="-pbkdf2"
ENC_OR_DEC=$1
INPUT_FILE=$2
OUTPUT_FILE=$3

[[ $# -lt 2 ]] && echo "Not enough arguments" && exit 127
[[ $ENC_OR_DEC != "-e" && $ENC_OR_DEC != "-d" ]] && echo "Invalid option: $ENC_OR_DEC" && exit 127
[[ -z $INPUT_FILE || ! -f $INPUT_FILE ]] && echo "Invalid input file: $INPUT_FILE" && exit 127

if [ ! -v PASSWORD ]
then
    echo -n "Enter your password : "
    read -s PASSWORD
    echo
fi

CMD="openssl enc $ENC_OR_DEC $ALGORITHM $ADDITIONAL_HASH $ENCODING -k $PASSWORD -in $INPUT_FILE"

[[ ! -z $OUTPUT_FILE && -e $OUTPUT_FILE ]] && echo "File already exists: ${OUTPUT_FILE}" && OUTPUT_FILE=""
[[ ! -z $OUTPUT_FILE ]] && CMD="${CMD} -out ${OUTPUT_FILE}"

echo "Out: ${OUTPUT_FILE}"

$CMD 2>/dev/null
exit $?
