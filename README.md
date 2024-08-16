# sxm-docker

Docker wrapper around [sxm-player](https://github.com/AngellusMortis/sxm-player)

[![CI Status](https://github.com/AngellusMortis/sxm-docker/actions/workflows/docker-stable.yml/badge.svg)](https://github.com/AngellusMortis/sxm-docker/actions/workflows/docker-stable.yml)

> **warning**
>
> Designed for PERSONAL USE ONLY
>
> `sxm-player` is a 100% unofficial project and you use it at your own
> risk. It is designed to be used for personal use with a small number
> of users listening to it at once. Similar to playing music over a
> speakers from the radio directly. Using `sxm-player` in any corporate
> setting, to attempt to pirate music, or to try to make a profit off
> your subscription may result in you getting in legal trouble.

## Usage

**NOTE**: `-it` is required when running this from command line (and not
via systemd, Portainer, etc.). If you do not pass `-it`, you will not have
proper color support and `SIGINT` (CTRL+C) will not work.

### Anonymous HLS Proxy

This will create an anonymous HLS proxy you can connect to with any
compatible client (i.e. ffmpeg).

``` {.sourceCode .console}
docker run --rm -it \
    -e SXM_USERNAME=username \
    -e SXM_PASSWORD=password \
    -p 9999:9999 \
    ghcr.io/angellusmortis/sxm-docker:latest
$ ffmpeg -y -i http://127.0.0.1:9999/octane.m3u8 -f mp2 output.mp3
```

### Channel Archiver

This will stream a given channel and automatically [archive and
process](https://sxm-player.readthedocs.io/en/latest/usage.html) the
stream.

``` {.sourceCode .console}
docker run --rm -it \
    -v /path/to/output:/output \  # volume mount for your archive
    -e SXM_USERNAME=username \
    -e SXM_PASSWORD=password \
    -e SXM_ARCHIVE=octane \
    ghcr.io/angellusmortis/sxm-docker:latest
```

### Plugins

#### `sxm-discord`: Discord Bot

This will run a Discord bot using the [sxm-discord plugin
player](https://sxm-discord.readthedocs.io/en/latest/usage.html). Can be
combined with `SXM_ARCHIVE` env to also archive anything the bot plays.

```bash
docker run --rm -it \
    -e SXM_USERNAME=username \
    -e SXM_PASSWORD=password \
    -e SXM_DISCORD_TOKEN=token \
    ghcr.io/angellusmortis/sxm-docker:latest
```
