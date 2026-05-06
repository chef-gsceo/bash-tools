#!/usr/bin/env bash
#Utility for remote management (WOL, SSH, RSYNC)

IP="XXX.XXX.X.XXX"	# server ip
MAC="XX:XX:XX:XX:XX:XX" # server mac
SSH_NAME="XXX" 		# ssh alias for your server
HOSTNAME="XXX"		# custom host name


# userspace

info() {

        printf "[INFO] %s\n" "$1"
}

error() {

        printf "[ERROR] %s\n" "$1" >&2
}

usage() {

	printf "[USAGE]:\n"
	printf "\"pc init\" 					-- wake up ${HOSTNAME}\n"
	printf "\"pc sshinit\" 					-- wake up ${HOSTNAME} + ssh connection\n"
	printf "\"pc pull path/on/${HOSTNAME} path/on/client\" 		-- rsync files\n"
	printf "\"pc\" 						-- ssh connection to ${HOSTNAME}\n"
}

# shared

ping_wait() {
        printf "\r[WAIT] Initialisation ...."
                while ! ping -c 1 "$IP" >/dev/null 2>&1; do
                printf "\r\033[K[WAIT] Initialisation ."
                sleep 0.3

                printf "\r\033[K[WAIT] Initialisation .."
                sleep 0.3

                printf "\r\033[K[WAIT] Initialisation ..."
                sleep 0.3

                printf "\r\033[K[WAIT] Initialisation ...."
                sleep 0.3

                done

        printf " \n"
        info "${HOSTNAME} is online"
}

wake() {
        wakeonlan "$MAC" >/dev/null 2>&1
        info "Sending magic packet to ${HOSTNAME}..."
        sleep 1
        info "Waking up ${HOSTNAME}..."
}

ssh_connect() {
	info "Connecting to ${HOSTNAME}..."
	ssh "$SSH_NAME"
}


# COMMANDS

cmd_init() {

	wake
	ping_wait
}

cmd_sshinit() {

	wake
	ping_wait
	ssh_connect
}

cmd_pull() {

        if [ $# -lt 2 ]; then
                error "not enough arguments"
                usage
                exit 1
        fi

        if ! ping -c 1 "$IP" >/dev/null 2>&1; then
                error "${HOSTNAME} is not available"
		info "Internet connection and ssh-access is required for RSYNC with ${HOSTNAME}"
		usage
		exit 1
        fi


        local from="$1"
        local to="$2"

	info "Starting RSYNC"
	rsync -avz --progress "$SSH_NAME":"$from" "$to"

}

cmd_sshdefault() {
        if ! ping -c 1 "$IP" >/dev/null 2>&1; then
                error "${HOSTNAME} is not available"
                info "Internet connection and ssh-access is required for ssh-connection with ${HOSTNAME}"
                usage
                exit 1
        fi

	ssh_connect
}


# main
case "${1:-}" in
  init)
    cmd_init
    ;;
  sshinit)
    cmd_sshinit
    ;;
  pull)
    shift
    cmd_pull "$@"
    ;;
  "")
    cmd_sshdefault
    ;;
  *)
    error "unknown command"
    usage
    exit 1
    ;;
esac

