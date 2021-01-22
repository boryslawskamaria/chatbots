#!/bin/bash
#coding=utf-8

set -euo pipefail

# to enable remote execution
cd "$(dirname "$0")"
CWD="${PWD}"

# Initialize submodules
git submodule update --init --recursive --progress

# Create venv
virtualenv -p /usr/bin/python3 .env
source .env/bin/activate

# Install requirements
pip3 install --upgrade pip
python3 --version
pip3 --version
pip3 install -r requirements.txt

# Install RASA
cd "${CWD}"
cd submodules/rasa
poetry install --no-root --no-interaction
cd "${CWD}"
cd submodules/rasa
pip install .
rasa -h

# Prepare RASA tests
cd "${CWD}"
cd submodules/rasa
make prepare-tests-ubuntu # when you're asked for sudo password, press Ctrl+C

