#!/usr/bin/env python3
# coding: utf-8

import requests
from time import sleep
from random import randint, getrandbits
from Crypto.PublicKey import RSA

with open("priv_key","r") as f:
	keypair = RSA.importKey(f.read())
RICH_GUY_ID = "2021-6329-0004"
HOST = "http://homo-accerus.interiut.ctf"
HEADERS = {
	'User-Agent': 'Bank/5.0 (x64; rv:85.0) Masterfox/83.0'
}

def encrypt(transfer_amount: int) -> int:
    return pow(transfer_amount,keypair.e,keypair.n)

def create_user(name, lastname):
	res = requests.post(HOST + "/users/create", 
		data= {
		"name": name,
		"lastname": lastname
		},
		headers = HEADERS
	)
	return res.json()["uid"]


def send_money(sender, receiver, amount):
	res = requests.post(HOST + "/transactions/make", 
		data= {
		"sender": sender,
		"receiver": receiver,
		"rsa-encrypted-amount": encrypt(amount)
		},
		headers = HEADERS
	)
	return res.json()["tid"]

def get_infos(uid):
	res = requests.post(HOST + "/users/get-infos", 
		data= {
		"uid": uid
		},
		headers = HEADERS
	)
	return res.json()


uids = []
uids.append(create_user("Master","Fox"))
# sleep(randint(1, 12))
uids.append(create_user("Michel","La Poutre"))
# sleep(randint(1, 12))
send_money(RICH_GUY_ID, uids[0], 12)
print(get_infos(uids[0]))

# sleep(randint(1, 12))
uids.append(create_user("John","Smith"))
# sleep(randint(0, 2))
print(get_infos(uids[len(uids) - 1]))

for i in range(12):
	send_money(RICH_GUY_ID, uids[randint(0, len(uids) - 1)], randint(4, 77))
	sleep(randint(0, 12))

print(get_infos(uids[0]))
send_money(RICH_GUY_ID, uids[0], 35)
print(get_infos(uids[0]))

for i in range(3):
	sleep(randint(0, 12))
	send_money(RICH_GUY_ID, uids[randint(0, len(uids) - 1)], randint(4, 77))
	if bool(getrandbits(1)):
		get_infos(uids[randint(0, len(uids) - 1)])


print(get_infos(uids[0]))
sleep(randint(0, 12))
send_money(RICH_GUY_ID, uids[0], 10)
print(get_infos(uids[0]))
