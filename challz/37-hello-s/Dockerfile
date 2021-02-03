FROM registry.alfred.cafe/interiut/interiut-base-ssh

COPY hello.c /challenge/hello.c
RUN apt -y update && apt -y --no-install-recommends install libssl-dev libc-dev
COPY flag /flag

RUN gcc -o ./challenge ./hello.c -lcrypto && \
	chmod 0400 /flag && chown cracked:cracked /flag && \
	chown cracked:cracked /challenge/challenge && chmod +s /challenge/challenge

