FROM phzfi/ubuntu32:bionic-latest

ADD scripts/provision.sh /opt
ADD tests/* /opt/

RUN /opt/provision.sh

ADD etc/* /etc

CMD ["/etc/init.d/nginx"]
