#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset

export SXM_HOST=0.0.0.0

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
    echo "Running HLS proxy..."
fi

ARGS=""
if [[ -n ${SXM_USERNAME} ]]; then
  ARGS="${ARGS} --username ${SXM_USERNAME}"
fi
if [[ -n ${SXM_PASSWORD} ]]; then
  ARGS="${ARGS} --password ${SXM_PASSWORD}"
fi

sxm-player --username $SXM_USERNAME --password $SXM_PASSWORD
