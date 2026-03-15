#!/bin/bash

source utils/git_utils.sh

LATEST_VER=$(get_remote_repo_tag_lv https://github.com/gohugoio/hugo)

if [ -z "$LATEST_VER" ]; then
   echo "Failed to get the latest version of hugo..."
   exit 1
fi

OS=linux
ARCH=amd64
TMP_PATH=/tmp
ARTIFACT="hugo_extended_${LATEST_VER}_${OS}-${ARCH}.deb"
WGET_CMD="wget -c -P $TMP_PATH https://github.com/gohugoio/hugo/releases/latest/download/$ARTIFACT"

$WGET_CMD
RES=$?

if [ "$RES" -ne 0 ]; then
    echo "Failed to downlolad arftifact: $ARTIFACT"
    exit 1
fi

sudo dpkg -i "$TMP_PATH/$ARTIFACT"
RES=$?

if [ "$RES" -ne 0 ]; then
    echo "Failed to install arftifact: $TMP_PATH/$ARTIFACT"
    exit 1
fi

echo "Done"
echo "Checking version..."
hugo version