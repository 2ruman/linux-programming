#!/bin/bash

function get_time() {
	echo $(date '+%Y-%m-%d_%H-%M-%S')
}

function create_out_file() {
	local out_file=$1
	[ -z $out_file ] && out_file=a.out
	[ -f $out_file ] && mv $out_file $out_file.$(get_time).bak
	touch $out_file
}

function main() {
	local target_file=$1
	local clip_file=$target_file.clp
	local start_point=$2
	local end_point=$3
	local is_found=false

	# For example...	
	#local start_point="# Truman Customization - START"
	#local end_point="# Truman Customization - END"

	[ -z $target_file ] || [ ! -f $target_file ] && { echo "Target file doesn't exist..."; exit 0; }
	[ -z "$start_point" ] || [ -z "$end_point" ] && { echo "Invalid input..."; exit 0; }

	echo "Clipping from \"$start_point\" to \"$end_point\""

	create_out_file $clip_file

	while read line
	do
		if [[ $line  == $start_point* ]]; then
			is_found=true
			printf "#\n" >> $clip_file
		fi

		if [ "$is_found" = true ]; then
			printf "$line\n" >> $clip_file
		fi

		if [[ $line == $end_point* ]]; then
			is_found=false
			printf "#\n" >> $clip_file
		fi
	done < $target_file
	echo -e "Done!\nResult file is $clip_file"
}

# Main Script
main "$@"
