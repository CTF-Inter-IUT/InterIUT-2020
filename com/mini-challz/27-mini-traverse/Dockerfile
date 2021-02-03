FROM nginx:latest

WORKDIR /

RUN apt-get -y update && apt-get -y install python3 python3-pip neovim
RUN pip3 install flask uwsgi markdown

COPY ./web/ /app/
COPY ./flag /
COPY ./server.ini /
COPY ./traverse_nginx.conf /etc/nginx/nginx.conf
COPY ./start.sh /docker-entrypoint.d/

EXPOSE 8000
