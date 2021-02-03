FROM debian:buster-slim

ENV TIMEZONE Europe/Paris

RUN apt -y --no-install-recommends update && \
	apt -y --no-install-recommends install \
	gcc libssl-dev openssh-server bash nano neovim && \
	ssh-keygen -A

RUN useradd chall --shell /bin/bash -p coucou -d /challenge/ && \
    useradd cracked -p coucou --no-create-home && \
    echo chall:interiut | chpasswd && \
    rm /etc/motd && \
	mkdir -p /run/sshd

WORKDIR /challenge/

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e"]
