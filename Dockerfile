FROM phzfi/debian-php-fpm:latest

WORKDIR /var/www/html

ADD scripts/provision.sh /opt
ADD tests/* /opt/

RUN /opt/provision.sh

COPY etc/ /etc
