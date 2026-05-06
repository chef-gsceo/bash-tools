#!/usr/bin/env bash

# colors
# load average
C_LOAD="\e[1;37m"
# cpu temperature
C_CPU="\e[1;32m"
# disk temperature
C_NVME="\e[1;36m"
# gpu temperature
C_GPU="\e[1;95m"
# color reset
C_RESET="\e[0m"

# another terminal
printf '\e[?1049h'
# restore terminal on exit
trap 'printf "\e[?1049l"' EXIT

while true; do

    #cursor control
    tput cup 0 0
    tput ed 

    # load average parsing
    LOAD=$(awk '{print $1, $2, $3}' /proc/loadavg)
    printf "${C_LOAD}load: ${LOAD}${C_RESET}\n"

    # sensors parsing
    sensors | sed 's/ *(.*)//' | grep -v 'Adapter' | sed '/^$/d' | while read -r line; do

        case "$line" in
            k10temp-*)
                printf "${C_CPU}${line}${C_RESET}\n"
                ;;
            nvme-*)
                printf "${C_NVME}${line}${C_RESET}\n"
                ;;
            amdgpu-*)
                printf "${C_GPU}${line}${C_RESET}\n"
                ;;

            Tctl:*)
                printf "${C_CPU}${line}${C_RESET}\n"
                ;;
            Composite:*)
                printf "${C_NVME}${line}${C_RESET}\n"
                ;;
            edge:*|junction:*|mem:*|PPT:*|fan1:*|vddgfx:*)
                printf "${C_GPU}${line}${C_RESET}\n"
                ;;

            *)
                printf "${line}\n"
                ;;
        esac

    done
    
    sleep 1

done