#!/bin/bash
echo 'Ejecutando: configure_secure.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

# rationale: add port of postgres to firewall rules public
# solo para centos completo?
$SUDO firewall-cmd --zone=public --add-port=5432/tcp --permanent
$SUDO firewall-cmd --reload
