#!/bin/bash

./services/ConfigDHCPv6.sh
./services/ConfigDns64.sh
./services/ConfigRadvd.sh
./infrastructure/ConfigTayga.sh $1
tail /var/log/syslog
tail /var/log/messages
atk6-parasite6 eth0
