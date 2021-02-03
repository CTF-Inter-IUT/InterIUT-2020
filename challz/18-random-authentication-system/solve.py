#!/usr/bin/env python3
#coding: utf-8

from arc4 import ARC4
from pwn import *

context.log_level = 'WARNING'

class random_auth():
	key = "AAAAAAAAAAAAAAAA"
	arc4 = ARC4(key)

	act_connect = "connect"
	act_disconnect = "disconnect"
	act_list = "list"

	tokens = {}

	def __init__(self, host, port):
		self.host=host
		self.port=port

	def encrypt(data, hex_decode=False):
		if hex_decode:
			data = bytes.fromhex(data)
		return arc4.decrypt(data)

	def connect(self, user, password):
		p = remote(self.host, self.port)
		p.sendline("connect " + user + ":" + password)
		self.tokens[user] = p.recvline().decode()
		print(user + " connected.")

	def disconnect(self, user):
		p = remote(self.host, self.port)
		p.sendline("disconnect " + user)
		print(p.recvline().decode().strip())
		p.close()

	def list(self, user):
		p = remote(self.host, self.port)
		p.sendline("list " + user + ":"+ self.tokens[user])
		print(p.recvline().decode().strip())
		p.close()
		

p = random_auth("localhost", 5000)
p.connect("kbowman", "A"*900)
