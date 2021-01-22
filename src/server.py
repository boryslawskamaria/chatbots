#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import subprocess
import time
import urllib.request


class Server:
    def __init__(self, rasa_port, rasa_actions_port):
        self.rasa_port = str(rasa_port)
        self.rasa_actions_port = str(rasa_actions_port)
        self.process = None
        self.address = 'http://localhost'
        self.last_bot_message = None

    def run(self):
        self.process = subprocess.Popen([
                './src/run-rasa-server.sh',
                '--bot-path', 'chatbot',
                '--rasa-port', self.rasa_port,
                '--rasa-actions-port', self.rasa_actions_port,
            ])
        start_time = time.time()
        while True:
            try:
                print('RASA server code:', str(urllib.request.urlopen(self.address + ":" + str(self.rasa_port) + "/").getcode()))
                break
            except urllib.error.URLError:
                if time.time() - start_time > 500:
                    raise TimeoutError('ERROR: RASA server seems not to be running!')
                time.sleep(1)  # This exception is caught when RASA server is not yet fully started, so we just wait for it

    def stop(self):
        self.process.terminate()

    def get_address_without_port(self):
        return self.address

    def get_address_with_port(self):
        return self.address + ':' + self.grpc_port
