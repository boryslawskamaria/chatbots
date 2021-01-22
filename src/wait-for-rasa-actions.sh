#!/bin/bash
#coding=utf-8

# Script waits till rasa action service is run.
# Typically you will invoke this script just after run-rasa-actions.sh one.

set -euo pipefail

# Enable remote execution
cd "$(dirname "$0")"
cd ..

# Parse arguments
if [ $# -ne 1 ]; then
    echo "Usage: $0 <actions_port>"
    exit 2
fi

ACTIONS_PORT=$1

while [[ "$(curl -X POST -s -o /dev/null -w ''%{http_code}'' localhost:${ACTIONS_PORT}/webhook)" != "400" ]]; do echo "waiting for rasa actions service..." && sleep 5; done
