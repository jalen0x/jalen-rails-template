#!/bin/bash
# Runs once when the Kamal `db` accessory container boots with an empty data
# dir. The official postgres image already creates POSTGRES_USER and
# POSTGRES_DB via its env-var bootstrap, so here we just add the extra
# databases that Rails' multi-db setup needs (cache / queue / cable).
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
  CREATE DATABASE ${POSTGRES_DB}_cache OWNER $POSTGRES_USER;
  CREATE DATABASE ${POSTGRES_DB}_queue OWNER $POSTGRES_USER;
  CREATE DATABASE ${POSTGRES_DB}_cable OWNER $POSTGRES_USER;
EOSQL
