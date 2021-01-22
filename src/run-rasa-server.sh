#!/bin/bash
#coding=utf-8

# to enable remote execution
cd "$(dirname "$0")"
cd ..

# Parse arguments
bot_path="chatbot"
rasa_port=5005
rasa_actions_port=5055
model="models"

help_message="
This script runs RASA server and RASA action server
using files from /<bot-path>/.

Usage:
    $0

Options:
    --bot-path <bot-path>
    # Chatbot directory name.

    [--rasa-port <rasa-port>=\""${rasa_port}"\"]
    # Port, RASA server will run on.
    # Remember, that this port must match the number in
    # /${bot_path}/credentials.yml.

    [--rasa-actions-port <rasa-actions-port>=\"${rasa_actions_port}\"]
    # Port, RASA action server will run on.
    # Remember, that this port must match the number in
    # /${bot_path}/endpoints.yml.

    [--model <model>=\"${model}\"]
    # Path to the model file or models directory. If <model> is a directory
    # latest model from this directory will be used.
    # The path is relative to the /${bot_path}/.
"

source ./src/parse_options.sh

# Check arguments correctness
if [ -z "${bot_path// }" ]; then  # Check if bot_path is empty or contains only whitespaces
    echo "Missing argument --bot_path"
    printf "$help_message\n" 1>&2
    exit 2
fi

# Prepare
source .env/bin/activate

_terminate_jobs() {
  kill $(jobs -rp)
}
trap _terminate_jobs TERM INT

./src/run-rasa-actions.sh "${bot_path}" "${rasa_actions_port}" &
timeout --foreground 60 bash -c './src/wait-for-rasa-actions.sh '"${rasa_actions_port}" || exit 1


cd "./${bot_path}"
# Run rasa server
rasa run --model "${model}"\
         --endpoints "endpoints.yml"\
         --port "${rasa_port}"\
         --cors \*\
         --enable-api\
         --credentials "credentials.yml"\
         --debug &

wait
trap - TERM INT
wait
