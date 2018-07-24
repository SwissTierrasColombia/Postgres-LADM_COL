#!/bin/bash
echo 'Ejecutando: install_postgresql_postgis.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

# rationale: validate postgres 9.6 instalation
if [ -f /usr/pgsql-9.6/bin/pg_ctl ]; then
  echo 'Postgres ya está instalado. Nada que hacer.'
else

# rationale: install postgres
echo "Instalando PostgreSQL"
$SUDO yum localinstall -y https://download.postgresql.org/pub/repos/yum/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
$SUDO yum install -y postgresql10-server
echo "Se ha terminado la instalación de Postgresql"

# rationale: mostrar como se desinstala
echo "Para desinstalar use # yum erase postgresql10*"

# rationale: mostrar como se crea una base de datos
cat << 'EOF'
# ¿Cómo crear un usuario y una base de datos?
$ sudo su postgres
$ psql
> CREATE USER nombre_usuario WITH PASSWORD 'clave';
> CREATE DATABASE nombre_db WITH OWNER = nombre_usuario ENCODING = 'UTF8' TABLESPACE = pg_default CONNECTION LIMIT = -1;
$ vim /var/lib/pgsql/9.6/data/pg_hba.conf
#host   DATABASE        USER            ADDRESS                 METHOD
local   all             all                                     trust
host    all             all             127.0.0.1/32            md5
host    all             all             localhost               md5
host    all             all             ::1/128                 md5
host    all             all             0.0.0.0/0               md5 # important!
$ sudo systemctl restart postgresql-10.service
EOF

# rationale: install postgis
echo "Instalando Postgis"
$SUDO yum install -y epel-release
$SUDO yum install -y postgis24_10 postgis24_10-utils
echo "Postgis Instalado"

# rationale: mostrar como se instala postgis sobre una base de datos
# link: https://postgis.net/docs/postgis_installation.html
cat << 'EOF'
# ¿Cómo instalar postgis en tu base de datos?
$ sudo su postgres
$ /usr/pgsql-10/bin/psql -p 5432
> CREATE DATABASE mi_base_de_datos;
> \connect mi_base_de_datos;
> CREATE EXTENSION postgis SCHEMA public; # or other?
> CREATE EXTENSION postgis_topology;
> CREATE EXTENSION ogr_fdw;
> SELECT postgis_full_version();
# ¿Otra manera? https://postgis.net/docs/postgis_installation.html
psql -d mi_base_de_datos -c "CREATE EXTENSION postgis;"
psql -d mi_base_de_datos -c "CREATE EXTENSION postgis_topology;"
EOF

fi
