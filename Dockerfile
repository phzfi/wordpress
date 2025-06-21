FROM phzfi/debian:bookworm-latest

WORKDIR /var/www/html

ADD scripts/provision.sh /opt
ADD tests/* /opt/

RUN /opt/provision.sh

COPY etc/ /etc

# daemon must be disabled so the container won't exit immediately
CMD ["/usr/sbin/php-fpm8.3", "--fpm-config", "/etc/php/8.3/fpm/php-fpm.conf"]
