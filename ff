#!/usr/bin/env bash

# fnd is a search tool based on GREP [debug mode]



#functions

#how to use
usage() {
	printf "[USAGE] ff \"pattern1|pattern2\" path/to/file \n"
}

# info preset
info() {
	printf "[INFO] %s\n" "$1"
}

# error preset
error() {
	printf "[ERROR] %s\n" "$1" >&2
}



#arguments
pattern="$1"
target="$2"



#start
#arguments check
info "arguments check..."
	if [ -z "$pattern" ]; then
		error "no pattern input"
		usage
		printf " \n"
		exit 1
	fi
info "arguments exist"



#file check
info "file check..."
	if [ ! -f "$target" ]; then
		error "file \"$target\" not found"
		usage
		printf " \n"
		exit 1
	fi
info "file exists"



#grep + result check
info "Search in progress..."
printf " \n"
	if grep -E -i --color=auto "$pattern" "$target"; then
		printf " \n"
		info "Success & exit"
		printf " \n"
		exit 0
	else
		error "pattern \"$pattern\" not found in \"$target\""
		info "Fail & exit"
		printf " \n"
		exit 1
	fi
