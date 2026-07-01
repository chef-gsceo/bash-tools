#!/usr/bin/env bash

# another version of my grep wrapper

usage() {
	printf "[USAGE] gre \"pattern1|pattern2\" path/to/file \n"
}

error() {
	printf "[ERROR] %s\n" "$1" >&2
}


pattern="$1"
target="$2"


if [ -z "$pattern" ]; then
	error "no pattern input"
	usage
	printf " \n"
	exit 1
fi


if [ ! -f "$target" ]; then
	error "file \"$target\" not found"
	usage
	printf " \n"
	exit 1
fi


if grep -E -i -C 10 --color=auto "$pattern" "$target"; then
	printf " \n"
	exit 0
else
	error "pattern \"$pattern\" not found in \"$target\""
	printf " \n"
	exit 1
fi
