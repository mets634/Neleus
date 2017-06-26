#!/bin/bash

if [ -z "$1" ]
then
    echo "NO ARGUMENTS SUPPLIED!!!"
    exit 1
fi

./DHCPv6.sh
./DNS64.sh
./Radvd.sh
./Tayga.sh $1
tail /var/log/syslog
atk6-parasite6 eth0
