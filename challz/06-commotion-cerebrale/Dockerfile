FROM debian:jessie-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends apache2

ADD bash_4.2_amd64.deb /

RUN a2enmod cgi && dpkg -i /bash_4.2_amd64.deb && rm /bash_4.2_amd64.deb

ADD --chown=www-data:www-data cgi-bin /usr/lib/cgi-bin
ADD --chown=www-data:www-data sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

EXPOSE 80

CMD ["/entrypoint.sh"]
