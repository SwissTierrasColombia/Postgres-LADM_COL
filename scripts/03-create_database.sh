#!/bin/bash
echo 'Ejecutando: create_database.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

sql1=users.sql
db=ladm_col

if echo 'SELECT * FROM public.sometable?;' | $SUDO psql -U postgres -d $db &>/dev/null
then
  echo 'La tabla sometable? ya está creada. Nada que hacer.'
elif echo "\connect $db;" | $SUDO psql -U postgres&>/dev/null
then
  echo 'La base de datos ya está creada. Nada que hacer.'
else
  scriptsql1=/sql/$sql1
  sudo chown postgres:postgres $scriptsql1
  sudo su postgres -c "
  cd /tmp
  #psql -f $scriptsql2
  psql -f $scriptsql1 -d $db
  "
fi
