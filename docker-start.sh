#!/bin/sh
set -ex

service nginx start
service php5-fpm start

cd ~torrent
gosu torrent /rutorrent.sh

