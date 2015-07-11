# rtorrent + rutorrent

## Run a data container
rtorrent configuration and session files will be keep in
this data container.
```Shell
docker run --name rutorrent-data nuimk/rutorrent /bin/true
```

## Run rutorrent

Mount your torrent data directory to /torrent/download. everything under this
folder will be changed the owner to 1000.
```Shell
docker run -d --name rutorrent --volumes-from rutorrent-data \
    -v ~/download:/torrent/download \
    -p 80:80 nuimk/rutorrent
```

#Attach tmux
rtorrent is running inside tmux session. If you want to attach to tmux session, 
run below command

If you wonder why script command is necessary, see this https://github.com/docker/docker/issues/728.

```Shell
docker exec -u torrent -it rutorrent env TERM=xterm script -q -c 'tmux attach' /dev/null
```

For simplicity, no authentication required to access rutorrent page.

