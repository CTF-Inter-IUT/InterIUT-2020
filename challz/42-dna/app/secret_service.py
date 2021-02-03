#!/usr/bin/env python3
# coding: utf-8

import socket

with open("./flag", 'r') as f:
    FLAG = f.read()

IP: str = socket.gethostbyname(socket.gethostname())
PORT: int = 1337
BUFFER_SIZE: int = 4096

# Open socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((IP, PORT))
s.listen(128)

print("Connection opened on {}:{}".format(IP,PORT))

try:
    while True:
        conn, addr = s.accept()
        print("Connection from {}".format(addr[0]))

        conn.send(bytes("salut", "utf-8"))

except KeyboardInterrupt:
    print("Server closed")

