#!/bin/bash

# This script will setup a DNS server that will translate
# all ipv4 addresses to ipv6 addresses so that Tayga may
# translate them back. This server's dns64 prefix must
# match the ipv6's network prefix with an additional 'ffff'.


name="ConfigDns64"


if ! hash bind  2>/dev/null; then
    echo "[$name]Bind9 not found. Installing module..."
    apt-get install bind9
fi

echo "[$name]Writing DNS64 config file to BIND9..."
echo "options {
    directory \"/var/cache/bind\";
    auth-nxdomain no;
    listen-on-v6 { any; };

    allow-query { any; };
    allow-query-cache { any; };
    recursion yes;

    dns64 6d65:7473:3633:3400:ffff::/96 {
        clients { any; };
        exclude { ::1/0; };
    };
};" > /etc/bind/named.conf.options

echo "[$name]Setting bind9 only to only respond to AAAA requests..."
echo "RESOLVCONF=yes
OPTIONS=\"-u bind\"" > /etc/default/bind9

echo "[$name]Restarting DNS server..."
service bind9 restart
