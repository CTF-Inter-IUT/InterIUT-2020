FROM registry.alfred.cafe/interiut/interiut-base-flask

RUN apk add --no-cache gcc g++ make libffi-dev openssl-dev redis python3-dev && pip3 install pycrypto flask-redis

COPY ./app/ /challenge/
COPY ./priv_key /challenge/
COPY ./flag /
COPY ./redis.conf /

COPY ./start_redis.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/start_redis.sh
