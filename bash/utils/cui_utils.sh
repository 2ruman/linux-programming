#!/bin/bash

BLK='\033[0;30m'    # Black
RED='\033[0;31m'    # Red
GRN='\033[0;32m'    # Green
YLW='\033[0;33m'    # Yellow
BLU='\033[0;34m'    # Blue
PUP='\033[0;35m'    # Purple
CYA='\033[0;36m'    # Cyan
WHT='\033[0;37m'    # White
NOC='\033[0m'       # No Color(=Reset)

function print_BLU() { echo -e "${BLU}${*}${NOC}"; }
function print_grn() { echo -e "${GRN}${*}${NOC}"; }
function print_red() { echo -e "${RED}${*}${NOC}"; }
function print_wht() { echo -e "${WHT}${*}${NOC}"; }
function print_ylw() { echo -e "${YLW}${*}${NOC}"; }

# Exclamation Mark    : \U0021
# Paragraph Separator : \U2029
# Information Source  : \U2139
# Leftwards  Arrow    : \U2190
# Upwards Arrow       : \U2191
# Rightwards Arrow    : \U2192
# Downwards Arrow     : \U2193
# Left Right Arrow    : \U2194
# Up Down Arrow       : \U2195
# Black Star          : \U2605
# White Star          : \U2606
# Lightoing           : \U2607
# Eighth Note         : \U266A
# Warning Sign        : \U26A0
# Check Mark          : \U2713

function log_dent() { echo -e " ${BLK}\U2029${NOC} ${*}"; }
function log_step() { echo -e " ${GRN}\U2192${NOC} ${*}"; }
function log_chk()  { echo -e " ${GRN}\U2713${NOC} ${*}"; }
function log_over() { echo -e " ${PUP}\U2607${NOC} ${*}"; }
function log_info() { echo -e " ${CYA}\U2139${NOC} ${*}"; }
function log_warn() { echo -e " ${YLW}\U26A0${NOC} ${*}"; }
function log_err()  { echo -e " ${RED}\U0021${NOC} ${*}"; }
function log_star() { echo -e " ${YLW}\U2605${NOC} ${*}"; }
function log_note() { echo -e " ${BLK}\U266A${NOC} ${*}"; }

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
