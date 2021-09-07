#!/bin/bash

: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_ESC=255}

BACKTITLE=" Welcome! - Truman - <truman.t.kim@gmail.com>"
TITLE="          [ Fix Serial Number for ADB ]          "
CHECKLIST=""

DIALOG=dialog
ACMD_GET_DEVICE_LIST="adb devices -l"

DEV_SERIALS=()
DEV_PRODS=()
DEV_MODELS=()

DUMP=n
CNT=0
RET=$DIALOG_OK

TMP_FILE=$(tempfile 2>/dev/null) || TMP_FILE=/tmp/test$$
trap "rm -f $TMP_FILE" 0 1 2 5 15

function get_device_info() {
    while read -a line
    do
        if [ ! ${line[0]} = "" ] && [ ${line[1]} = "device" ]
        then
            let CNT+=1
            DEV_SERIALS+=(${line[0]})
            for (( i=2; i<${#line[0]}; i++ )); do
                IFS=':'
                if [[ ${line[i]} == product:* ]]
                then
                    read -ra TEMP <<< ${line[i]}
                    DEV_PRODS+=(${TEMP[1]})
                elif [[ ${line[i]} == model:* ]]
                then
                    read -ra TEMP <<< ${line[i]}
                    DEV_MODELS+=(${TEMP[1]})
                fi
                IFS=' '
            done
        fi
    done < <($ACMD_GET_DEVICE_LIST)
}

function dump() {
    if [ $DUMP = y ]
    then
        for (( i=0; i<${#DEV_SERIALS[@]}; i++ )); do
            echo -e "Serial #$i is ${DEV_SERIALS[i]}\n"
        done
        for (( i=0; i<${#DEV_PRODS[@]}; i++ )); do
            echo -e "Product #$i is ${DEV_PRODS[i]}\n"
        done
        for (( i=0; i<${#DEV_MODELS[@]}; i++ )); do
            echo -e "Model #$i is ${DEV_MODELS[i]}\n"
        done
    fi
}

function ensure_normality() {
    if [ $CNT -ne ${#DEV_SERIALS[@]} ] || [ $CNT -ne ${#DEV_PRODS[@]} ] || [ $CNT -ne ${#DEV_MODELS[@]} ]
    then
        echo "Wrong device information..."
        exit 0
    fi
}

function show_dialog() {

    for (( i=0; i<$CNT; i++ )); do
        CHECKLIST="$CHECKLIST ${DEV_SERIALS[i]} ${DEV_PRODS[i]}(${DEV_MODELS[i]}) off "
    done
    CHECKLIST="$CHECKLIST clear Empty on"
    let CNT+=1
    $DIALOG --backtitle "$BACKTITLE" \
        --title "$TITLE" \
        --ok-label "OK" \
        --radiolist "\nSelect a target you want to stay connected" 0 0 $CNT \
        $CHECKLIST 2> $TMP_FILE
}

function handle_result() {

    RET=$?
    case $RET in
        $DIALOG_OK)
            SELECTED=$(cat $TMP_FILE)
            if [ $SELECTED = clear ]; then
                unset ANDROID_SERIAL
            else
                export ANDROID_SERIAL=$SELECTED
            fi
            echo -e "\nFinished!";;
        $DIALOG_CANCEL | $DIALOG_ESC)
            echo -e "\nCanceled....";;
        *)
            echo "Unexpected return code... $RET";;
    esac
}

function main() {

    get_device_info

    dump

    ensure_normality

    show_dialog

    handle_result
}

# Main Script
main $@
