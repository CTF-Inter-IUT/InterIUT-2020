FROM registry.alfred.cafe/interiut/interiut-base-python

RUN apk add --no-cache gcc libc-dev && \
	pip install pycrypto

#Copy to /challenge
COPY ./app/ ./
COPY ./flag /flag

EXPOSE 1337

CMD [ "python", "./server.py" ]
