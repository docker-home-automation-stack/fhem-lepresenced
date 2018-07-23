#!/bin/sh

echo "Starting FHEM lepresenced ..."
[ ! -s /data/lepresenced.conf ] && cp /lepresenced.conf /data/lepresenced.conf
rm -f /var/run/lepresenced.pid
/lepresenced
