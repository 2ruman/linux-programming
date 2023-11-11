#!/bin/bash

PROG=cp_path_of_exe.sh

ARG=ls
$PROG $ARG
echo "Copied: $(xsel -ob)"

ARG=java
$PROG $ARG
echo "Copied: $(xsel -ob)"
