#!/bin/bash
echo 'Ejecutando: create_database.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

db=ladm_col
scriptsql1=/sql/create_LADM_COL.sql

# rationale: check created db
if $SUDO psql -U postgres -l  | grep "^ ${db}\b" &>/dev/null
then
  echo 'La base de datos ya está creada. Nada que hacer.'
else
  $SUDO chown postgres:postgres $scriptsql1
  $SUDO su postgres -c "psql -f $scriptsql1"
fi
