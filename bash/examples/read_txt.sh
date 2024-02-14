#!/bin/bash

INPUT_FILE="./read_txt_sample.txt"

lines=()
while IFS= read -r line
do
    lines+=("$line")
done < $INPUT_FILE

echo -e Read "${#lines[@]}" lines '\U2193'

for i in "${lines[@]}"; do
    echo "$i"
done
