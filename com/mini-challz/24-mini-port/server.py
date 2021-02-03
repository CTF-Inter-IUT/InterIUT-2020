#!/usr/bin/env python3
#coding: utf-8

import socket

IP: str = "0.0.0.0"
PORT: int = 1337
FLAG: bytes = b'ENSIBS{Und3f1n3d_b3h4v10ur5_ftw}\n','utf-8'

# Open socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind((IP, PORT))
s.listen(64) #maximum 1 connection

print("Connection opened on {}:{}".format(IP,PORT))

try:
    while True:
        conn, addr = s.accept()
        print("Connection from {}".format(addr[0]))
        conn.send(FLAG)
        conn.close()

except KeyboardInterrupt:
    print("Server closed")


