#!/bin/bash

name="ConfigDHCPv6"

if ! hash wide-dhcpv6-server 2>/dev/null; then
    echo "[$name]Wide-DHCPv6 not found. Installing module..."
    apt-get install wide-dhcpv6-server
fi

echo "[$name]Configuring DHCPv6 server settings..."
echo "option domain-name-servers 6d65:7473:3633:34::1;
option domain-name \"Hacked.by.Neleus\";" > /etc/wide-dhcpv6/dhcp6s.conf

echo "[$name]Restarting DHCPv6 server..."
service wide-dhcpv6-server restart
