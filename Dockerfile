FROM centos:7
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == \
systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]

# please see https://hub.docker.com/_/centos/

MAINTAINER Jorge Useche <juusechec@gmail.com>
USER root

#WORKDIR /sql
# no sudo needed
ADD ./scripts/ /scripts
ADD ./sql/ /sql
RUN chmod 0755 /scripts/*.sh
RUN /scripts/01-install_basics.sh
RUN /scripts/02-install_postgres_postgis.sh
RUN /scripts/03-create_database.sh
RUN /scripts/04-populate_database.sh
RUN /scripts/05-configure_secure.sh

# Remove unnecesary
RUN yum clean all
RUN rm -rf /var/cache/yum

EXPOSE 5432
#CMD ["sh", "/scripts/start.sh"]
