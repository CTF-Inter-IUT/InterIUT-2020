FROM registry.alfred.cafe/interiut/interiut-base-flask

RUN apk add --no-cache tor

COPY ./app/ /challenge/
COPY ./tor_conf/ /var/lib/tor/hidden_service/
COPY ./start_tor.sh /docker-entrypoint.d/
COPY ./start_flag_service.sh /docker-entrypoint.d/

RUN chmod 700 /var/lib/tor/hidden_service/