#!/bin/bash -x
echo 'Ejecutando: populate_database.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

db='ladm_col'
schema='test_ladm_col'
scriptsql1='/sql/backup_LADM_COL.sql'

function populate_with_ili2db {
  # rationale: create directory for LADM_COL model repo and executables
  $SUDO mkdir /opt/interlis
  pushd /opt/interlis

  # rationale: defining data config
  LADM_COL_VERSION='V2_2_1'
  # OJO, LADM_COL_DIR debería ser recursivo
  LADM_COL_DIR='/opt/interlis/LADM_COL_REPO/ISO;/opt/interlis/LADM_COL_REPO/Catastro_Multiproposito;/opt/interlis/LADM_COL_REPO/Catastro_Multiproposito/legacy;/opt/interlis/LADM_COL_REPO/Condicion_Amenaza_Riesgo'
  LADM_COL_MODELS="Catastro_Registro_Nucleo_$LADM_COL_VERSION;Avaluos_$LADM_COL_VERSION;Ficha_Predial_$LADM_COL_VERSION"
  # OJO, esto es temporal UNICAMENTE porque la última versión no se ha lanzado como release, así que cojo el master
  LADM_COL_ZIP_URL='https://api.github.com/repos/AgenciaImplementacion/LADM_COL/zipball/master'
  #LADM_COL_ZIP_URL=$(curl https://api.github.com/repos/AgenciaImplementacion/LADM_COL/releases/latest | grep -i zipball_url | awk -F '": "' '{print $2}' RS='",')

  # rationale: download ili files of LADM_COL
  $SUDO wget "$LADM_COL_ZIP_URL" -O LADM_COL.zip &>/dev/null
  unzip LADM_COL.zip &>/dev/null
  mv AgenciaImplementacion-LADM_COL-* LADM_COL_REPO

  # rationale: download ili2pg
  $SUDO wget http://www.eisenhutinformatik.ch/interlis/ili2pg/ili2pg-3.11.2.zip &>/dev/null
  unzip ili2pg*.zip &>/dev/null

  # rationale: populate database
  java -jar /opt/interlis/ili2pg-3.11.2/ili2pg.jar \
  --schemaimport \
  --dbhost localhost \
  --dbusr usuario_ladm_col \
  --dbpwd clave_ladm_col \
  --dbdatabase ladm_col \
  --dbschema "$schema" \
  --setupPgExt \
  --coalesceCatalogueRef \
  --createEnumTabs \
  --createNumChecks \
  --coalesceMultiSurface \
  --coalesceMultiLine \
  --strokeArcs \
  --beautifyEnumDispName \
  --createUnique \
  --createGeomIdx \
  --createFk \
  --createFkIdx \
  --createMetaInfo \
  --smart2Inheritance \
  --defaultSrsCode 3116 \
  --models "$LADM_COL_MODELS" \
  --modeldir "$LADM_COL_DIR"
  popd
}

# rationale: check if empty, with select in table "public.la_baunit"
SQLResult=$(echo "SELECT * FROM $schema.la_baunit LIMIT 0" | $SUDO psql -U postgres -d $db 2>&1) # error and output to variable
#echo "SQL result: $SQLResult"

# rationale if table not exists, execute populations, if not have error, the query was success
if ! echo "$SQLResult" | grep 'ERROR' &>/dev/null
then
  echo "Esquema $schema NO está vacio. Nada que hacer."
else
  $SUDO chown postgres:postgres $scriptsql1
  $SUDO su postgres -c "psql -f $scriptsql1 -d $db"
  echo 'Poblando la base de datos con ili2db.'
  populate_with_ili2db
fi
