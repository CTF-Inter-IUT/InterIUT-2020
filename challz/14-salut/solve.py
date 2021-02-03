#!/usr/bin/env python3
# coding: utf-8

from pwn import *

IP: str = '127.0.1.1'
PORT: int = 4444

def decode(value: str,base: int) -> int:
    value = value.strip()
    return int(value,base) 

salut = remote(IP,PORT)

i = 2
while True:
    value: str = salut.recvline().decode()
    if "ENSIBS" in value:
        print("\nFlag = {}".format(value),end="")
        break
    else:
        print(str(i) + ") " + value,end="")

        decoded = ""
        value_list = value.split(" ")[:-1]
        for elt in value_list:
            decoded += chr(decode(elt,i))

        print(decoded)
        salut.sendline(bytes(decoded,'utf-8'))
        i += 1
