FROM debian
MAINTAINER kavehmz@gmail.com

COPY provision.sh /tmp
RUN /tmp/provision.sh

RUN mkdir /var/run/sshd
CMD ["echo", "'Starting SSH'"]
CMD ["/usr/sbin/sshd", "-D"]