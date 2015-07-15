# rtorrent + rutorrent

## Usage

Pick a folder to store downloaded files, for example, `~/torrent` then run following commands

```sh
docker run -d --name rutorrent -v ~/torrent:/torrent/download \
    -p 80:80 nuimk/rutorrent
```

Optional, start a data container to keep rtorrent configuration and session files
```sh
docker run --name rutorrent-data --volumes-from rutorrent tianon/true
```


## Access rtorrent

rtorrent is running inside tmux session. If you want to attach to tmux session, 
run below command


```sh
docker exec -u torrent -it rutorrent env TERM=xterm script -q -c 'tmux attach' /dev/null
```

If you wonder why script command is necessary, see this https://github.com/docker/docker/issues/728.

For simplicity, no authentication required to access rutorrent page.

