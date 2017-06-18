#!/bin/bash

# assumptions:
# 1) DNS will use interface eth0.
# 2) Device has an external DNS server to access.


if ! hash bind9  2>/dev/null; then
    echo "[*]Bind9 not found. Installing module..."
    apt-get install bind9
fi

echo "[*]Writing DNS64 config file to BIND9..."
echo "options {
    directory "/var/cache/bind";

    listen-on-v6 { any; };

    dns64 6D65:7473:3633:34::/96 {
        recursive-only no;
        exclude {
            ::/0;
        };
        clients {
            ::1;
            6D65:7473:3633:34::/64;
        };
    };
};" > /etc/bind/named.conf.options

echo "Restarting DNS server..."
service bind9 restart
