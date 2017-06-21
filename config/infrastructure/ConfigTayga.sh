#!/bin/bash

if ! hash tayga 2>/dev/null; then
    echo "[$0]Tayga not found. Installing module..."
    apt-get install tayga
fi

# remove old interface

echo "[$0]Deleting old nat64 interface..."
ip link delete nat64 2>/dev/null

# make tayga log file

echo "[$0]Creating db file for tayga..."
mkdir -p /var/db/tayga

# edit tayga configuration file

echo "[$0]Configuring Tayga..."
echo "tun-device nat64
ipv4-addr 192.168.255.1 
prefix 6d65:7473:3633:3400:ffff::/96
dynamic-pool 192.168.255.0/24
data-dir /var/db/tayga" > /etc/tayga.conf

# push tayga's configurations

echo "[$0]Applying configurations..."
killall tayga
tayga --mktun

# edit routing table

echo "[$0]Configuring routing table..."
ip link set nat64 up
ip addr add $1 dev nat64
ip addr add 6d65:7473:3633:3400::1 dev nat64
ip route add 192.168.255.0/24 dev nat64
ip route add 6d65:7473:3633:3400:ffff::/96 dev nat64

echo "[$0]Allowing NAT44..."
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE # allow NAT44 forwarding

# start tayga

echo "[$0]Starting tayga..."
tayga
tail /var/log/syslog
