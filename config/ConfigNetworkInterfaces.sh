#!/bin/bash

name="ConfigNetworkInterfaces"

# assumptions:
# 1) eth0 is both in and out router interface.
# 2) eth0 already has an IP address (IPv4 or IPv6)
# that is connected to the internet


echo "[$name]Setting up static IPv6 address for interface eth0..."

# We'll add a (or another) IPv6 address to
# use as the router address
ifconfig eth0 inet6 add 6D65:7473:3633:34::1 


echo "[$name]Allowing IPv6 forwarding..."

sysctl -w net.ipv6.conf.all.forwarding=1
