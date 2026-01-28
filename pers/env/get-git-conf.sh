#!/bin/bash

cat << EOF
git config --global user.email "truman.t.kim@gmail.com"
git config --global user.name "2ruman"
git config --global merge.tool p4merge
git config --global diff.tool p4merge
git config --global difftool.prompt false
git config --global  -l
EOF
