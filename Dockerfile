FROM ubuntu:14.04
# FROM nuimk/ubuntu:14.04

ENV RUTORRENT_URI=https://bintray.com/artifact/download/novik65/generic/rutorrent-3.6.tar.gz\
    RUTORRENT_SHA1=5870cddef717c83560e89aee56f2b7635ed1c90d\
    RUTORRENT_PLUGINS_URI=https://bintray.com/artifact/download/novik65/generic/plugins-3.6.tar.gz\
    RUTORRENT_PLUGINS_SHA1=617625cda45c689f5505fbfdfb6cc4000bc6b1d9

RUN \
    locale-gen en_US.UTF-8 &&\
    update-locale LANG=en_US.UTF-8 &&\
    apt-get update &&\
    apt-get -y install software-properties-common &&\
    # ffmpeg ppa
    add-apt-repository -y ppa:mc3man/trusty-media &&\
    add-apt-repository -y ppa:nginx/stable &&\
    rm -rf /var/lib/apt/lists/*

RUN \
    # install required libraries
    apt-get update &&\
    apt-get -y install\
        curl\
        ffmpeg\
        mediainfo\
        nginx\
        php5-cli\
        php5-fpm\
        php5-geoip\
        rtorrent\
        tmux\
        unrar-free\
        unzip\
        wget &&\
    rm -rf /var/lib/apt/lists/*

RUN \
    cd /var/www &&\
    # install rutorrent
    wget -q -O rutorrent.tar.gz $RUTORRENT_URI &&\
    echo "$RUTORRENT_SHA1  rutorrent.tar.gz" | sha1sum -c - &&\
    tar -xf rutorrent.tar.gz &&\
    rm rutorrent.tar.gz &&\
    # install rutorrent plugins
    cd rutorrent &&\
    wget -q -O plugins.tar.gz $RUTORRENT_PLUGINS_URI &&\
    echo "$RUTORRENT_PLUGINS_SHA1  plugins.tar.gz" | sha1sum -c - &&\
    tar xf plugins.tar.gz &&\
    rm plugins.tar.gz &&\
    # correct files permission
    chmod -R 755 /var/www &&\
    # fix curl not found
    sed -i 's#\(\s*"curl"\s*=>\s*'"'"'\)''\('"'"'.*\)#\1/usr/bin/curl\2#g' /var/www/rutorrent/conf/config.php &&\
    chown -R www-data. /var/www

# remove default nginx config
RUN rm /etc/nginx/sites-available/* &&\
    rm /etc/nginx/sites-enabled/*
# add nginx config for rutorrent
COPY nginx /etc/nginx
RUN ln -s /etc/nginx/sites-available/rutorrent /etc/nginx/sites-enabled/rutorrent

RUN adduser --quiet --disabled-password --gecos "" --uid 1000 torrent
COPY rtorrent.rc /home/torrent/.rtorrent.rc
RUN mkdir -p /home/torrent/download /home/torrent/watch
RUN mkdir /home/torrent/rtorrent-session &&\
    chgrp www-data /home/torrent/rtorrent-session
RUN chown -R torrent. /home/torrent

COPY docker-entrypoint.sh /
COPY start.sh /

VOLUME ["/home/torrent/download", "/home/torrent/watch"]
ENTRYPOINT /docker-entrypoint.sh
CMD ["/start.sh"]

