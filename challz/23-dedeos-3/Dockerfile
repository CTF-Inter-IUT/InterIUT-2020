FROM registry.alfred.cafe/interiut/interiut-base-web

RUN apk add --no-cache iputils

COPY app /challenge
RUN chown -R root:root /challenge && chmod -R 555 /challenge
