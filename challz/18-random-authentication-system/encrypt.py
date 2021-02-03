#!/usr/bin/env python3
#coding: utf-8

from arc4 import ARC4

KEY = '\x31\xc0\x48\xbb\xd1\x9d\x96\x91\xd0\x8c\x97\xff\x48\xf7\xdb\x53\x54\x5f'

with open('secret.csv', 'r') as f:
    content = f.readlines()

for line in content:
    line = line.split(':')
    if len(line) > 1:
        c = ARC4(KEY)
        mdp = line[1]
        print(line[0] + ':' + c.encrypt(mdp).hex())
