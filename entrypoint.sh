#!/bin/bash

chown -R squid:squid /var/cache/squid
chown squid:squid /dev/stdout
rm -f /var/run/squid/squid.pid

set -e

# Cache initialization
DIR="/var/cache/squid"
if [ -d "$DIR" ]
then
	if [ ! "$(ls -A $DIR)" ]; then
        # if directory empty
        echo "[+] Cache directory initialization"
        /usr/sbin/squid -z -N -f /etc/squid/squid.conf
    fi
else
	echo "[-] Directory $DIR not found"
fi

# Run squid
/usr/sbin/squid -N -f /etc/squid/squid.conf

exec "$@"
