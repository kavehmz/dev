FROM debian
MAINTAINER kavehmz@gmail.com

ADD provision_base.sh /opt/
RUN chmod +x /opt/provision_base.sh
RUN /opt/provision_base.sh

ADD provision_perl.sh /opt/
RUN chmod +x /opt/provision_perl.sh
RUN /opt/provision_perl.sh

ADD provision_go.sh /opt/
RUN chmod +x /opt/provision_go.sh
RUN /opt/provision_go.sh

ADD provision_cloud.sh /opt/
RUN chmod +x /opt/provision_cloud.sh
RUN /opt/provision_cloud.sh

CMD ["/bin/bash"]