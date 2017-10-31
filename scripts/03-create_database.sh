#!/bin/bash
echo 'Ejecutando: create_database.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

sql1=users.sql
sql2=script_tables.sql
db=database

if echo 'SELECT * FROM public.sometable?;' | sudo psql -U postgres -d $db &>/dev/null
then
  echo 'La tabla sometable? ya está creada. Nada que hacer.'
elif echo "\connect $db;" | sudo psql -U postgres&>/dev/null
then
  echo 'La base de datos ya está creada. Nada que hacer.'
else
  cp $sql1 /tmp
  cp $sql2 /tmp
  scriptsql1=/tmp/$sql1
  scriptsql2=/tmp/$sql2
  sudo chown postgres:postgres $scriptsql1
  sudo chown postgres:postgres $scriptsql2
  sudo su postgres -c "
  cd /tmp
  psql -f $scriptsql1
  psql -f $scriptsql2 -d $db
  "
fi
