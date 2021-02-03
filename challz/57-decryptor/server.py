#!/bin/python3

import socket, select, os, sys, binascii
from Crypto.PublicKey import RSA

with open("/flag") as f:
	flag = f.read()
	
hote = ''
port = 2301

f = open('priv.pem','r')
key = RSA.importKey(f.read())


c1_flag =  pow(int("0x"+(binascii.b2a_hex(flag.encode())).decode(), 16), key.e, key.n)

soc = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
soc.bind((hote, port))
soc.listen(64)
print("[+] Server listening on port {} [+]\n".format(port))

connected_clients = []


while True:
	requested_connexions, wlist, xlist = select.select([soc], [], [], 0.05)
	for co in requested_connexions:
		connexion, infos = soc.accept()
		print("New connection from {}:{}".format(infos[0], infos[1]))
		connected_clients.append(connexion)

	ready_clients = []
	try:
		ready_clients, wlist, xlist = select.select(connected_clients, [], [], 0.05)

	except select.error:
		pass

	else:
		for client in ready_clients:
			rcv = client.recv(2048)
			if rcv != b'\n':
				try:
					c = int(rcv.decode())
					if c != c1_flag:
						if c ==  c1_flag *  pow(2, key.e, key.n) or c == c1_flag *  pow(3, key.e, key.n) or c == c1_flag *  pow(4, key.e, key.n):
							client.send(b"[+] Keep going...\n")
						else:
							m = pow(c,key.d,key.n)
							#connexion.send(bytes(str(c), 'UTF-8')+b"\n\n")
							client.send(b"[+] - Decrypted message :\n\n"+bytes(str(m), 'UTF-8')+b"\n\n")
							#connexion.send(bytes(hex(m), 'UTF-8')+b"\n")
							#connexion.send(bytes.fromhex(str(hex(m))[2:])+b"\n")
					else:
						print(1)
						client.send(b"[+] Sorry i'm not allowed to decrypt the flag...\n")

				except:
					try:
						client.send(b"[+] Please send a valid number\n")
					except:
						pass

for client in connected_clients:
	client.close()
soc.close()
