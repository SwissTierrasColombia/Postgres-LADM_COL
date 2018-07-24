#!/bin/bash -x
echo 'Ejecutando: configure_postgres.sh'

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

# rationale: init database
$SUDO /usr/pgsql-10/bin/postgresql-10-setup initdb

# rationale: enable service
$SUDO systemctl enable postgresql-10

# rationale: allow password authentication
$SUDO sed -i.bak 's/peer/trust/; s/ident/md5/' /var/lib/pgsql/10/data/pg_hba.conf

# rationale: allow connection from all origin IP's with password
$SUDO tee -a /var/lib/pgsql/10/data/pg_hba.conf << 'EOF'
host    all             all             0.0.0.0/0               md5
EOF

# rationale: allow listen address for all hostname
$SUDO sed -i.bak "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /var/lib/pgsql/10/data/postgresql.conf

# rationale: start service
$SUDO systemctl start postgresql-10.service
