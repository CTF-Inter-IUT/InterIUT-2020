#!/usr/bin/env python3
# coding: utf-8

import socket

with open("./flag", 'r') as f:
    FLAG = f.read()

with open("./lyrics",'r') as f:
        LYRICS = f.read().split('\n')[:-1]

IP: str = socket.gethostbyname(socket.gethostname())
PORT: int = 1337
BUFFER_SIZE: int = 4096

CONVERSION_TABLE = {
        0: "0", 1: "1",
        2: "2", 3: "3",
        4: "4", 5: "5",
        6: "6", 7: "7",
        8: "8", 9: "9",
        10: "A", 11: "B",
        12: "C", 13: "D",
        14: "E", 15: "F",
        16: "G", 17: "H",
        18: "I", 19: "J",
        20: "K", 21: "L",
        22: "M", 23: "N",
        24: "O", 25: "P",
        26: "Q", 27: "R",
        28: "S", 29: "T",
        30: "U", 31: "V",
        32: "W", 33: "X",
        34: "Y", 35: "Z",
}

def convert(value: int, base: int) -> str:
    """Convert value to base "base"

    :param value: The value in base 10
    :param base: The destination base
    :return: Value in base "base"
    :rtype: str
    """

    converted: str = ""
    pls_stop: bool = False

    while not pls_stop:
        if value // base == 0:
            pls_stop = True

        converted += CONVERSION_TABLE[value % base]
        value: int = value // base

    return converted[::-1]

# Open socket
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1) # Pour les tests
s.bind((IP, PORT))
s.listen(64)

print("Connection opened on {}:{}".format(IP,PORT))

while True:
    try:
        conn, addr = s.accept()
        print("Connection from {}".format(addr[0]))

        i = 2
        for line in LYRICS:
            # On envoie la ligne encodée en base i
            to_send: str = ''
            for c in line:
                to_send += str(convert(ord(c),i)) + " "
            conn.send(bytes(to_send + '\n','utf-8'))

            # On vérifie que la réponse est bien égale
            data = conn.recv(BUFFER_SIZE).decode().strip()
            if data == line:
                # Si elle est égale on continue 
                i += 1
                if line == LYRICS[-1]:
                    conn.send(bytes(FLAG + '\n','utf-8'))
                    conn.close()
                    break
            else:
                # Et c'est perdu
                conn.send(b"01000101 01110100   01100011 00100111 01100101 01110011 01110100   01110000 01100101 01110010 01100100 01110101\n")
                conn.close()
                break
    except BrokenPipeError:
        pass
    except KeyboardInterrupt:
        print("Server closed")
        exit()

