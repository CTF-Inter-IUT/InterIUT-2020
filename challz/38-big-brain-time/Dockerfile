FROM registry.alfred.cafe/interiut/interiut-base-ssh

RUN apt -y update && apt -y --no-install-recommends install gcc-multilib

COPY ./big_brain.c /challenge/

RUN gcc -m32 -o challenge big_brain.c && \
	chmod 0400 big_brain.c && \
	chown cracked:cracked /challenge/challenge && chmod +s /challenge/challenge && \
	chmod -r /challenge/challenge 