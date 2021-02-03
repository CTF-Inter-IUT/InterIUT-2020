FROM python:3-alpine

ENV TIMEZONE Europe/Paris

RUN addgroup --gid 666 challenge && \
	adduser --uid 666 --disabled-password --home=/challenge --ingroup challenge challenge

WORKDIR /challenge/