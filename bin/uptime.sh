#!/usr/bin/env bash

uptime | awk '{
    for (i = 2; i <= NF; i++) {
        if (i == NF-4 || i == NF-3)
            continue

        sub(/,$/, "", $i)
        printf "%s ", $i
    }
    printf "\n"
}'
