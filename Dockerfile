FROM phzfi/ubuntu32:bionic
RUN apt-get -y install nginx-extras
CMD ["/etc/init.d/nginx", "start"]
