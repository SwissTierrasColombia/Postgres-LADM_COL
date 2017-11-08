#!/bin/bash
echo 'Ejecutando: populate_database.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

db=ladm_col
scriptsql1=/sql/backup_LADM_COL.sql

# rationale: check if empty, with select in table "public.la_baunit"
if echo 'SELECT * FROM public.la_baunit' | $SUDO psql -U postgres -d $db &>/dev/null
then
  echo 'Esquema public no está vacio. Nada que hacer.'
else
  $SUDO chown postgres:postgres $scriptsql1
  $SUDO su postgres -c "psql -f $scriptsql1 -d $db"
fi
