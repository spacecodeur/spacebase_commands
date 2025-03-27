#!/bin/bash

show_help() {
    echo "Usage: $0 <username> <ip_address> [path_to_ssh_key]"
    echo "  username           : Username on the remote server"
    echo "  ip_address         : IP address of the remote server (must be valid)"
    echo "  path_to_ssh_key    : (optional) Path to the private SSH key (.pem)"
    echo "  If the SSH key is not specified, the command will use the standard SSH connection method."
}

if [[ $# -lt 2 ]]; then
    echo "Error: Two required parameters are missing."
    show_help
    exit 1
fi

USER=$1
SERVER=$2
KEY_PATH=$3

# Check if the IP address is valid (IPv4 format)
if ! [[ "$SERVER" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: The IP address '$SERVER' is not valid."
    show_help
    exit 1
fi

# If a key path is provided, validate its existence
if [[ -n "$KEY_PATH" ]]; then
    if [[ ! -f "$KEY_PATH" ]]; then
        echo "Error: The SSH key file '$KEY_PATH' does not exist."
        show_help
        exit 1
    fi
    SSH_CMD="ssh -i $KEY_PATH $USER@$SERVER"
else
    SSH_CMD="ssh $USER@$SERVER"
fi

# Compile and create the archive
[ -f release.tar.gz ] && rm release.tar.gz && \
./commands.sh fc/app/build-prod-and-compress

# copy the archive to the remote server
if [[ -n "$KEY_PATH" ]]; then
    # If an SSH key is specified
    scp -i "$KEY_PATH" release.tar.gz "$USER@$SERVER:/home/$USER/"
else
    scp release.tar.gz "$USER@$SERVER:/home/$USER/"
fi

# Check if the SCP command failed
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to copy the archive to the remote server."
    exit 1
fi

rm release.tar.gz

# Commands to execute on the remote server

$SSH_CMD "rm -rf /home/$USER/release"
$SSH_CMD "mkdir -p /home/$USER/release"
$SSH_CMD "tar -xzf /home/$USER/release.tar.gz -C /home/$USER/release"
$SSH_CMD "rm /home/$USER/release.tar.gz"

# Close the SSH session

$SSH_CMD "exit"