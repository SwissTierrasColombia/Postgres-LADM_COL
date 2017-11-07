#!/bin/bash -eux

# Do some stuffs
echo 'Wait for postgres initiation.'
# journalctl -f

exec /usr/sbin/init # To correctly start D-Bus thanks to https://forums.docker.com/t/any-simple-and-safe-way-to-start-services-on-centos7-systemd/5695/8
