#!/bin/bash

# This script will setup the network interface eth0
# to work with a static ipv6 address, as well as
# a DHCP-configured ipv4 address. When running the other
# services, you must make sure to match the ip addresses
# with the configured one in this file.

# configure interfaces file

echo "[$0]Configuring /etc/network/interfaces file..."
echo "auto lo
iface lo inet loopback

auto eth0 
iface eth0 inet dhcp
iface eth0 inet6 static
    address 6d65:7473:3633:3400::1
    netmask 64" > /etc/network/interfaces

# allow ip forwarding

echo "[$0]Allowing IPv6 forwarding..."
sysctl -w net.ipv6.conf.all.forwarding=1

# restart networking

echo "[$0]Restarting networking service..."
service networking stop
service networking start
