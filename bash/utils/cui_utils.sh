#!/bin/bash

function pause() {
    read -n 1 -r -s -p "Press any key to continue... "; echo
}

function pause2enter() {
    read -n 1 -r -s -p "Press enter to continue... " ans
    while true; do
        case $ans in
            "" ) echo ""; break;
            ;;
            * ) read -n 1 -r -s ans
            ;;
        esac
    done
}
