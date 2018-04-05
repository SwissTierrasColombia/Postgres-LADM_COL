FROM centos/systemd
#ENV container docker
# please see https://hub.docker.com/_/centos/

MAINTAINER Jorge Useche <juusechec@gmail.com>
USER root

#WORKDIR /sql
# no sudo needed
ADD ./scripts/ /scripts
#ADD ./sql/ /sql
RUN chmod 0755 /scripts/*.sh
RUN /scripts/01-install_basics.sh
RUN /scripts/02-install_postgres_postgis.sh
# others scripts are executed in entrypoint

# Remove unnecesary
RUN yum clean all
RUN rm -rf /var/cache/yum

EXPOSE 5432
CMD ["sh", "/scripts/docker-entrypoint.sh"]
