FROM nginx:alpine

ENV TIMEZONE Europe/Paris

# Installation uWSGI avec python3 et flask
RUN apk add --no-cache py3-pip uwsgi-python3 && \
    pip install --upgrade pip flask

RUN addgroup --gid 666 challenge && \
	adduser --uid 666 --disabled-password --home=/challenge --ingroup challenge challenge
WORKDIR /challenge/

# Copie des fichiers de configuration
COPY ./uwsgi.ini /etc/uwsgi/
COPY ./nginx.conf /etc/nginx/
COPY ./start_uwsgi.sh /docker-entrypoint.d/
RUN chmod +x /docker-entrypoint.d/start_uwsgi.sh

EXPOSE 80