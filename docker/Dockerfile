FROM debian
MAINTAINER kavehmz@gmail.com

ADD provision_base.sh /opt/
RUN chmod +x /opt/provision_base.sh
RUN /opt/provision_base.sh

ADD provision_perl.sh /opt/
RUN chmod +x /opt/provision_perl.sh
RUN /opt/provision_perl.sh

ADD provision_cloud.sh /opt/
RUN chmod +x /opt/provision_cloud.sh
RUN /opt/provision_cloud.sh

ADD provision_jvm.sh /opt/
RUN chmod +x /opt/provision_jvm.sh
RUN /opt/provision_jvm.sh

ADD provision_elixir.sh /opt/
RUN chmod +x /opt/provision_elixir.sh
RUN /opt/provision_elixir.sh

ADD provision_pg.sh /opt/
RUN chmod +x /opt/provision_pg.sh
RUN /opt/provision_pg.sh

ADD provision_go.sh /opt/
RUN chmod +x /opt/provision_go.sh
RUN /opt/provision_go.sh

RUN rm -rf /tmp/*

CMD ["/bin/bash"]