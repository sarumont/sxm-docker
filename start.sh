#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

export SXM_HOST=0.0.0.0

# MP3 proxy defaults (can be overridden via env)
export SXM_MP3_PORT=${SXM_MP3_PORT:-9998}

if [[ -n ${SXM_ARCHIVE+x} ]]; then
    export SXM_OUTPUT_FOLDER=/output
fi

if [[ -n ${SXM_DISCORD_TOKEN+x} ]]; then
    export SXM_PLAYER_CLASS=sxm_discord.DiscordPlayer

    echo "Running Discord bot..."
elif [[ -n ${SXM_ARCHIVE+x} ]]; then
    export SXM_PLAYER_CLASS=CLIPlayer
    export SXM_CLI_CHANNEL_ID=$SXM_ARCHIVE

    echo "Running archiver..."
else
    echo "Running HLS proxy + MP3 proxy (port ${SXM_MP3_PORT})..."
fi

sxm-player
