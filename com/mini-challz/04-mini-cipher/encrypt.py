#!/usr/bin/env python3
#coding: utf-8

from Crypto.Cipher import AES

KEY = b'\xcaV7Zs\xbb\xe3\xec\xcd~\x8ad\xf5ZA\xb7'
FLAG = b"ENSIBS{ju5t_u53_ROT13}PADDINGPAD"

def encrypt(msg):
    cipher = AES.new(KEY)
    return cipher.encrypt(msg)

ciphertext = FLAG
for i in range(20):
    ciphertext = encrypt(ciphertext)

print("KEY : {}\nCIPHERTEXT : {}\n".format(KEY,ciphertext))
