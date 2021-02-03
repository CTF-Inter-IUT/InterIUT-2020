#!/usr/bin/env python3
# coding : utf-8

"""
By Masterfox
Hide a message in a few tweets using morse in punctuation
"""

FILENAME = "tweets"
SECRET_MSG = "UN MESSAGE SECRET QUE PERSONNE NE VERRA".replace(' ','')
TWEET_MAX_LENGTH = 280
SHORT = '.'
LONG = '!'
MORSE_TABLE = {
        'a' : SHORT + LONG,
        'b' : LONG + SHORT + SHORT + SHORT,
        'c' : LONG + SHORT + LONG + SHORT,
        'd' : LONG + SHORT + SHORT,
        'e' : SHORT,
        'f' : SHORT + SHORT + LONG + SHORT,
        'g' : LONG + LONG + SHORT,
        'h' : SHORT + SHORT + SHORT + SHORT,
        'i' : SHORT + SHORT,
        'j' : SHORT + LONG + LONG + LONG,
        'k' : LONG + SHORT + LONG,
        'l' : SHORT + LONG + SHORT + SHORT,
        'm' : LONG + LONG,
        'n' : LONG + SHORT,
        'o' : LONG + LONG + LONG,
        'p' : SHORT + LONG + LONG + SHORT,
        'q' : LONG + LONG + SHORT + LONG,
        'r' : SHORT + LONG + SHORT,
        's' : SHORT + SHORT + SHORT,
        't' : LONG,
        'u' : SHORT + SHORT + LONG,
        'v' : SHORT + SHORT + SHORT + LONG,
        'w' : SHORT + LONG + LONG,
        'x' : LONG + SHORT + SHORT + LONG,
        'y' : LONG + SHORT + LONG + LONG,
        'z' : LONG + LONG + SHORT + SHORT
}

def to_morse(msg : str):
    if not msg == "":
        msg = msg.lower().strip()
        morse = ""
        for c in msg:
            morse += MORSE_TABLE[c]
        return morse

def end_tweet(nb_chr : int):
    print("=======================================================")

    if nb_chr <= TWEET_MAX_LENGTH:
        percentage =  round((nb_chr/TWEET_MAX_LENGTH)*100,2)
        print("✅ {} caractères sur {} max | {}% ".format(nb_chr, TWEET_MAX_LENGTH,percentage))
    else:
        print("❌ {} caractères sur {} max".format(nb_chr, TWEET_MAX_LENGTH))

    print("=======================================================")

char_idx = 0
char_count = 0
line = "init"
msg_written = ""
with open(FILENAME,"r") as f:
    # For each character in message
    while char_idx <= len(SECRET_MSG) and line:
        c = to_morse(SECRET_MSG[char_idx])
        unit_idx = 0
        # For each "SHORT" or "LONG" in c
        while unit_idx < len(c) and line:
            # Read the line
            line = f.readline().strip()
            # Check if not empty, continue tweet conceiving
            if line:
                if c[unit_idx] == SHORT:
                    line += SHORT
                else:
                    line += ' ' + LONG

                char_count += len(line)
                print(line)
                unit_idx += 1
            # if empty : change of tweet
            else:
                if char_count > 1:
                    end_tweet(char_count)
                    line = "temp"
                char_count = 0

        print()
        if unit_idx == len(c):
            msg_written += SECRET_MSG[char_idx]
        elif unit_idx > 0:
            print("Caractère {} non transmis".format(SECRET_MSG[char_idx]))

        char_count += 1
        char_idx += 1

print("\033[1;32;40m{}\033[1;31;40m{}\033[0;00;00m".format(msg_written,SECRET_MSG.replace(msg_written,'')))
