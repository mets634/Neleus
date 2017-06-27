#!/bin/bash

# This script will setup a server to send out router solicitations
# in order to con ipv4 users to use this machine as the router. The
# router's prefix must be the same as the static ipv6 address configured,
# and there must be a DHCPv6 server on the network.

name="ConfigRadvd"


# check for Radvd module
if ! hash radvd 2>/dev/null; then
    echo "[$name]Radvd not found. Installing module..."
    apt-get install radvd
fi

echo "interface eth0 {
    AdvSendAdvert on; # advertise router
    AdvOtherConfigFlag on; # make sure clients use DHCP server
    AdvDefaultPreference high; # make us top priority router

    # advertise every 3-10 seconds
    MinRtrAdvInterval 3;
    MaxRtrAdvInterval 10;

    prefix 6D65:7473:3633:3400::/64
    {
        AdvOnLink on;
        AdvAutonomous on; # clients should use SLAAC auto-configuration
        AdvRouterAddr on;
    };
};" > /etc/radvd.conf

echo "[$name]Starting service..."

# extra lines to deal with ungraceful shutdown
killall -9 radvd
radvd
