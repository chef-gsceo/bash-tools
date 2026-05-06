#!/usr/bin/env bash

# colors
# load average
C_LOAD="\e[1;37m"
# cpu temperature
C_CPU="\e[1;32m"
# disk temperature
C_NVME="\e[1;31m"
# gpu temperature
C_GPU="\e[1;95m"
# color reset
C_RESET="\e[0m"


while true; do
    clear

    # load average parsing
    LOAD=$(awk '{print $1, $2, $3}' /proc/loadavg)
    echo -e "${C_LOAD}load: ${LOAD}${C_RESET}"

    # sensors parsing
    sensors | sed 's/ *(.*)//' | grep -v 'Adapter' | sed '/^$/d' | while read -r line; do

        case "$line" in
            k10temp-*)
                echo -e "${C_CPU}${line}${C_RESET}"
                ;;
            nvme-*)
                echo -e "${C_NVME}${line}${C_RESET}"
                ;;
            amdgpu-*)
                echo -e "${C_GPU}${line}${C_RESET}"
                ;;

            Tctl:*)
                echo -e "${C_CPU}${line}${C_RESET}"
                ;;
            Composite:*)
                echo -e "${C_NVME}${line}${C_RESET}"
                ;;
            edge:*|junction:*|mem:*|PPT:*|fan1:*|vddgfx:*)
                echo -e "${C_GPU}${line}${C_RESET}"
                ;;

            *)
                echo "$line"
                ;;
        esac

    done

    sleep 1
done