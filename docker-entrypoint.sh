#!/bin/sh
set -ex

reset_permission() {
    chown -R torrent. /home/torrent/download
    chown -R torrent. /home/torrent/watch
}

reset_permission

exec "$@"

