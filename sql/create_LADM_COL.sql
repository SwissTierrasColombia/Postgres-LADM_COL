CREATE USER usuario_ladm_col WITH PASSWORD 'clave_ladm_col';
CREATE DATABASE ladm_col WITH OWNER = usuario_ladm_col ENCODING = 'UTF8' TEMPLATE = template0 TABLESPACE = pg_default CONNECTION LIMIT = -1;
ALTER USER usuario_ladm_col WITH SUPERUSER; --needed by plugin projectgenerator
--GRANT USAGE ON SCHEMA public TO usuario_ladm_col;
\connect ladm_col;
CREATE EXTENSION postgis SCHEMA public;
--CREATE EXTENSION postgis_topology SCHEMA public;
SELECT postgis_full_version();
