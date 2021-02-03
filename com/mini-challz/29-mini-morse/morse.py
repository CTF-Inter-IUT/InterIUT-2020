#!/usr/bin/env python3
# coding : utf-8

from pydub import AudioSegment
from pydub.playback import play

FLAG = "ENSIBS{0u4is_0ua1s_0uai5_c3st_g4gn3}"
DELIMS = ['{', '_', '}']

LIL_PAUSE = AudioSegment.silent(duration=200)
WORD_END = AudioSegment.silent(duration=500)

SHORTS = [ AudioSegment.from_file("oui_" + str(i) + ".wav") for i in range(1,5) ]
LONG = AudioSegment.from_file("non.wav")


def get_short(n=1):
    return AudioSegment.from_file

MORSE_TABLE = {
        'a' : SHORTS[0]+ LONG,
        'b' : LONG + SHORTS[2],
        'c' : LONG + SHORTS[0]+ LONG + SHORTS[0],
        'd' : LONG + SHORTS[1],
        'e' : SHORTS[0],
        'f' : SHORTS[1] + LONG + SHORTS[0],
        'g' : LONG + LONG + SHORTS[0],
        'h' : SHORTS[3],
        'i' : SHORTS[1],
        'j' : SHORTS[0]+ LONG + LONG + LONG,
        'k' : LONG + SHORTS[0]+ LONG,
        'l' : SHORTS[0]+ LONG + SHORTS[1],
        'm' : LONG + LONG,
        'n' : LONG + SHORTS[0],
        'o' : LONG + LONG + LONG,
        'p' : SHORTS[0]+ LONG + LONG + SHORTS[0],
        'q' : LONG + LONG + SHORTS[0]+ LONG,
        'r' : SHORTS[0]+ LONG + SHORTS[0],
        's' : SHORTS[2],
        't' : LONG,
        'u' : SHORTS[1] + LONG,
        'v' : SHORTS[2] + LONG,
        'w' : SHORTS[0]+ LONG + LONG,
        'x' : LONG + SHORTS[1] + LONG,
        'y' : LONG + SHORTS[0]+ LONG + LONG,
        'z' : LONG + LONG + SHORTS[1],
        '0' : LONG + LONG + LONG + LONG + LONG,
        '1' : SHORTS[0]+ LONG + LONG + LONG + LONG,
        '2' : SHORTS[1] + LONG + LONG + LONG,
        '3' : SHORTS[2] + LONG + LONG,
        '4' : SHORTS[3] + LONG,
        '5' : SHORTS[3] + SHORTS[0],
        '6' : LONG + SHORTS[3],
        '7' : LONG + LONG + SHORTS[2],
        '8' : LONG + LONG + LONG + SHORTS[1],
        '9' : LONG + LONG + LONG + LONG + SHORTS[0],
        '{' : SHORTS[0]+ LONG + LONG + SHORTS[0]+ LONG,
        '}' : SHORTS[0]+ LONG + LONG + SHORTS[0]+ LONG + LONG,
        '_' : SHORTS[1] + LONG + LONG + SHORTS[0]+ LONG
}


def to_morse(msg : str):
    morse = AudioSegment.silent()
    if not msg == "":
        msg = msg.lower().strip()
        for c in msg:
            if c in DELIMS:
                morse += WORD_END
            morse += MORSE_TABLE[c]
            if c in DELIMS:
                morse += WORD_END
            else:
                morse += LIL_PAUSE
    return morse


morse_msg = to_morse(FLAG)
morse_msg.export("chall.wav", format="wav")

