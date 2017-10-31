FROM centos:7.4.1708

MAINTAINER Jorge Useche <juusechec@gmail.com>
USER root

#WORKDIR /sql
ADD ./scripts/ /scripts
RUN chmod 0755 /scripts/*.sh
RUN /scripts/01-install_basics.sh
RUN /scripts/02-install_postgres_postgis.sh

# Remove unnecesary
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/*

EXPOSE 5432
CMD ["sh", "/scripts/start.sh"]
