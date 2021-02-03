FROM alpine:latest

ENV TIMEZONE Europe/Paris

RUN apk add --no-cache curl php7 apache2 apache2-utils \
    php7-apache2 \
    php7-session \
    composer texlive

RUN mkdir /challenge && \
    chown apache:apache /challenge && \
    sed -i "s#^DocumentRoot \".*#DocumentRoot \"/challenge\"#g" /etc/apache2/httpd.conf && \
    sed -i "s#/var/www/localhost/htdocs#/challenge#" /etc/apache2/httpd.conf && \
    printf "\n<Directory \"/challenge\">\n\tAllowOverride All\nOptions -Indexes\n</Directory>\n" >> /etc/apache2/httpd.conf && \
    printf "ErrorLog /dev/stderr\nTransferLog /dev/stdout\n" >> /etc/apache2/httpd.conf

WORKDIR /challenge

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]
