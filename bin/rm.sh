#!/bin/bash

REAL_RM="/usr/bin/rm"
protected_paths=("/" "$HOME")
protected_inodes=()

for p in "${protected_paths[@]}"; do
    [ -e "$p" ] && protected_inodes+=("$(stat -c '%d:%i' "$p" 2>/dev/null)")
done

for target in "$@"; do
    case "$target" in
        -*) continue ;;
    esac
    resolved=$(realpath -m -- "$target" 2>/dev/null)
    [ -z "$resolved" ] && continue

    for p in "${protected_paths[@]}"; do
        if [ "$resolved" = "$p" ]; then
            echo "[PERMISSION DENIED]: Protected path: \"$resolved\"" >&2
            exit 1
        fi
    done

    if [ -e "$resolved" ]; then
        dev_ino=$(stat -c '%d:%i' "$resolved" 2>/dev/null)
        for p in "${protected_inodes[@]}"; do
            if [ "$dev_ino" = "$p" ]; then
                echo "[PERMISSION DENIED]: \"$target\" resolves to protected path" >&2
                exit 1
            fi
        done
    fi
done

exec "$REAL_RM" "$@"