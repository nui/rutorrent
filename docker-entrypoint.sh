#!/bin/sh
set -ex

reset_permission() {
    chown -R torrent. /home/torrent/download
    chown -R torrent. /home/torrent/watch
}

reset_permission

if [ $# -gt 0 ]; then
    exec "$@"
else
    exec /start.sh
fi

