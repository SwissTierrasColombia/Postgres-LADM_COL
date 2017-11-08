#!/bin/bash -eux

# Do some stuffs
echo 'Wait for postgres initiation.'

exec /usr/sbin/init & # To correctly start D-Bus thanks to https://forums.docker.com/t/any-simple-and-safe-way-to-start-services-on-centos7-systemd/5695/8

/scripts/03-create_database.sh
/scripts/04-populate_database.sh
#/scripts/05-configure_secure.sh

journalctl -f
