#!/bin/bash

name="ConfigDns64"

# assumptions:
# 1) DNS will use interface eth0.
# 2) Device has an external DNS server to access.


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
    dns64 6d65:7473:3633:3400:ffff::/96 {
        clients { any; };
        exclude { ::1/0; };
    };
};" > /etc/bind/named.conf.options

echo "[$name]Restarting DNS server..."
service bind9 restart
