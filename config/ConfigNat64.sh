#!/bin/bash

name="ConfigNat64"

if ! tayga 2>/dev/null; then
    echo "[$name]Tayga not found. Installing module..."
    apt-get install tayga
fi

echo "[$name]Creating log file..."
mkdir -p /var/db/tayga

echo "[$name]Creating configuration file..."
echo "tun-device nat64
ipv4-addr 192.168.255.1
prefix 6d65:7473:3633:34::/96
dynamic-pool 192.168.255.0/24
data-dir /var/db/tayga" > /usr/local/etc/tayga.conf

echo "[$name]Setting up tayga..."
service tayga start
killall -9 tayga
tayga --mktun
ip link set nat64 up
ip addr add $1 dev nat64
ip addr add 6d65:7473:3633:34::1 dev nat64
ip route add 192.168.255.0/24 dev nat64
ip route add 6d65:7473:3633:34::/96 dev nat64
tayga
