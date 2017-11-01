FROM centos:7.4.1708

MAINTAINER Jorge Useche <juusechec@gmail.com>
USER root

#WORKDIR /sql
# no sudo needed
ADD ./scripts/ /scripts
ADD ./sql/ /sql
RUN chmod 0755 /scripts/*.sh
RUN /scripts/01-install_basics.sh
RUN /scripts/02-install_postgres_postgis.sh
#RUN /scripts/03-install_postgres_postgis.sh
#RUN /scripts/04-populate_database.sh

# Remove unnecesary
RUN yum clean all

EXPOSE 5432
CMD ["sh", "/scripts/start.sh"]
