#!/bin/bash

: ${DIALOG_OK=0}
: ${DIALOG_CANCEL=1}
: ${DIALOG_ESC=255}

BACKTITLE="Welcome! - Truman - <truman.t.kim@gmail.com>"
TITLE="[ Select & Remove ]"
DIALOG=dialog

# You can use your own del command instead in order to prevent permanet deletion
RM="rm -rf"

CNT=0
CHECKLIST=""

TMP_FILE=$(tempfile 2>/dev/null) || TMP_FILE=/tmp/test$$
trap "rm -f $TMP_FILE" 0 1 2 5 15

for f in $(ls $PWD); do
	if [ -d "${f}" ]; then
		TYPE="directory"
	elif [ -f "${f}" ]; then
		TYPE="file"
	else
		TYPE="etc"
	fi
	CHECKLIST="$CHECKLIST $f $TYPE off "
    let CNT=CNT+1
done

if [[ "$CNT" == 0 ]] ; then
	echo "Nothing to remove..."
	exit 0
else
	let CNT=CNT+1
fi

$DIALOG --backtitle "$BACKTITLE" \
	--title "$TITLE" \
	--checklist "\nSelect files to remove under the path : $PWD" 0 50 $CNT \
	$CHECKLIST 2> $TMP_FILE

RET=$?

case $RET in
	$DIALOG_OK)
		SELECTED=$(cat $TMP_FILE)
		$RM $SELECTED
		echo -e "\nFinished!";;
	$DIALOG_CANCEL | $DIALOG_ESC)
    	echo -e "\nCanceled....";;
	*)
		echo "Unexpected return code... $RET";;
esac
