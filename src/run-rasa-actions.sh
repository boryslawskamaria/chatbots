#!/bin/bash
#coding=utf-8

# Script runs actions service needed for a bot
# Typically you will invoke wait-for-rasa-actions.sh script just after this one.

set -euo pipefail

# Enable remote execution
cd "$(dirname "$0")"
cd ..

# Parse arguments
if [ $# -ne 2 ]; then
    echo "Usage: $0 <bot_path> <actions_port>"
    exit 2
fi

BOT_PATH=$1
ACTIONS_PORT=$2

source .env/bin/activate

# http://veithen.io/2014/11/16/sigterm-propagation.html
_terminate_jobs() {
  kill $(jobs -rp)
}

trap _terminate_jobs INT TERM

cd "${BOT_PATH}"
rasa run actions -p "${ACTIONS_PORT}" &

wait
