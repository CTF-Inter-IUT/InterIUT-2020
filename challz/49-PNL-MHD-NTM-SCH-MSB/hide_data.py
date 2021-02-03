#!/usr/bin/env python3
# coding: utf-8

from PIL import Image
from bitstring import BitArray

RED = 0
GREEN = 1
BLUE = 2
OPACITY = 3

FLAG = open("flag","rb").read()
FLAG_BITS = BitArray(FLAG).bin
bits_stored = 0

INPUT_FILE = "39-pnl-mhd-ntm-sch-msb.png"
OUTPUT_FILE = "39-chall.png"

IMG_IN = Image.open(INPUT_FILE)
width, height = IMG_IN.size

IMG_OUT = Image.new('RGBA', (width, height))

# On parcourt tous les pixels
for x in range(width):
    for y in range(height):
        # On récupère le pixel
        pixel = IMG_IN.getpixel((x, y))
        if bits_stored < len(FLAG_BITS):
            # La honte de ma vie
            red_chan = int(FLAG_BITS[bits_stored] + BitArray(bytes([pixel[0]])).bin[1:],2)
            # On stocke le pixel dans la nouvelle image
            new_pixel = ( red_chan, ) + pixel[1:]
            IMG_OUT.putpixel((x, y), new_pixel)
            bits_stored += 1
        else:
            IMG_OUT.putpixel((x, y), pixel)

IMG_OUT.save(OUTPUT_FILE)
