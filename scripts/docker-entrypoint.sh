#!/bin/bash -eux

# Do some stuffs
echo 'Wait for postgres initiation.'

#exec /usr/sbin/init & # To correctly start D-Bus thanks to https://forums.docker.com/t/any-simple-and-safe-way-to-start-services-on-centos7-systemd/5695/8

# rationale: inicia los scripts cuando systemd esté activo
function execScripts {
while ! systemctl status &> /dev/null
do
  sleep 2
  echo "/usr/sbin/init not ready..."
done

echo "/usr/sbin/init ready!"
#chmod 0755 /scripts/*.sh
rm -rf /var/lib/pgsql/9.6/data/*
/scripts/03-configure_postgres.sh
/scripts/04-create_database.sh
/scripts/05-populate_database.sh
#/scripts/05-configure_secure.sh
journalctl -f
}

execScripts &

exec /usr/sbin/init
