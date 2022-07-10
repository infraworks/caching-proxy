#!/bin/sh

# Necessary because squid forks itself to an unprivileged process.
chown -R proxy.proxy /var/cache/squid-deb-proxy
chown proxy.proxy /dev/stdout
rm -f /var/run/squid-deb-proxy.pid

set -e

# Start services
service dbus start
service avahi-daemon start

# Cache initialization
DIR="/var/cache/squid-deb-proxy"
if [ -d "$DIR" ]
then
	if [ ! "$(ls -A $DIR)" ]; then
        # if directory empty
        echo "[+] Cache directory initialization"
        /usr/sbin/squid3 -z -N -f /etc/squid-deb-proxy/squid-deb-proxy.conf
    fi
else
	echo "[-] Directory $DIR not found"
fi

# Run squid3
/usr/sbin/squid3 -N -f /etc/squid-deb-proxy/squid-deb-proxy.conf

exec "$@"
