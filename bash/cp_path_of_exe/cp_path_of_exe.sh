#!/bin/bash

DEBUG=n

CP_TO_CLIPBOARD="xsel -b"

FILE=$1

[ -z $FILE ] && echo "Missing target file" && exit 127

DIR_OF_FILE=$(dirname $(which $FILE) 2>/dev/null)

[ $? ] && echo -n $DIR_OF_FILE | $CP_TO_CLIPBOARD

[ $DEBUG = "y" ] && echo "Copied : $DIR_OF_FILE"
