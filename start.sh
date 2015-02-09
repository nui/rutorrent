#!/bin/sh
set -ex

TMUX_BIN=${TMUX_BIN:-/usr/bin/tmux}

service nginx start
service php5-fpm start
"$TMUX_BIN" new-session -d 'sudo -H -u torrent rtorrent'

TMUX_SERVER_PID="$("$TMUX_BIN" run-shell 'echo $TMUX' | cut -d ',' -f 2)"
set +x
# wait until tmux server died
while kill -0 $TMUX_SERVER_PID > /dev/null 2>&1; do
    sleep 1
done

