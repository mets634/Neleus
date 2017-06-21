#!/bin/bash

name="ConfigRadvd"

# assumptions:
# 1) Router adv. will be sent on interface eth0.
# 2) Interface eth0 has IPv6 address 6D65:7473:3633:34::1.


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

echo "[$0]Allowing IP forwarding..."
sysctl -w net.ipv6.conf.all.forwarding=1
sysctl -w net.ipv4.ip_forward=1
service networking stop
service networking start

# extra lines to deal with ungraceful shutdown
killall -9 radvd
radvd