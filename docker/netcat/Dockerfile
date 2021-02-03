FROM alpine:latest

ENV TIMEZONE Europe/Paris

RUN apk add --no-cache socat gcc libressl-dev libc-dev

RUN addgroup --gid 666 challenge && \
	adduser --uid 666 --disabled-password --home=/challenge --ingroup challenge challenge

WORKDIR /challenge/

CMD ["su", "-c", "socat TCP-LISTEN:1337,reuseaddr,fork EXEC:/challenge/challenge,stderr,pty", "- challenge"]
