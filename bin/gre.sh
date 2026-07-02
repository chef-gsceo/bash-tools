#!/usr/bin/env bash

# another version of my grep wrapper

usage() {
	printf "[USAGE] gre \"pattern1|pattern2\" path/to/file \n"
}

error() {
	printf "[ERROR] %s\n" "$1" >&2
}


pattern="$1"
shift


if [ -z "$pattern" ]; then
	error "no pattern input"
	usage
	printf " \n"
	exit 1
fi


if [ "$#" -eq 0 ]; then
    error "no target files input"
    usage
    printf "\n"
    exit 1
fi

for target in "$@"; do
    if [ ! -f "$target" ]; then
        error "file \"$target\" not found"
        exit 1
    fi
done


if grep -i -E -H -C 10 --color=always "$pattern" "$@" | less -R; then
	printf " \n"
else
	error "pattern \"$pattern\" not found in target files"
	printf " \n"
	exit 1
fi
