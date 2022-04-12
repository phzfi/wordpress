#FROM phzfi/ubuntu32:bionic
FROM phzfi/ubuntu32:bionic-20211118

WORKDIR /var/www/html

ADD scripts/provision.sh /opt
ADD tests/* /opt/

RUN /opt/provision.sh

ADD etc/* /etc

# daemon must be disabled so the container wont exit immediately
CMD ["nginx", "-g", "daemon off;"]
