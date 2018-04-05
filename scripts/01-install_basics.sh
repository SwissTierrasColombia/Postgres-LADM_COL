#!/bin/bash
echo 'Ejecutando: install_basics.sh'

# rationale: list of applications
list=(vim git nmap telnet tree wget sudo unzip)

# rationale: list of packages (no bin app entry)
# example, mlocate install locate, not mlocate bin
list_packages=(mlocate epel-release open java-1.8.0-openjdk)

# rationale: install applications
install=installed
for p in ${list[*]}
do
  if which $p&>/dev/null
  then
    echo "$p ya está instalado."
  else
    install=no_installed
  fi
done

# rationale: install packages, slow to verify than application
for p in ${list_packages[*]}
do
  if yum list installed $p&>/dev/null
  then
    echo "El paquete $p ya está instalado."
  else
    install=no_installed
  fi
done

# rationale: set a default sudo
if [ -z "$SUDO" ]; then
  SUDO=''
fi

# rationale: if someone is not installed, install all
if [ "$install" = "installed" ]
then
  echo 'Utilities ya están instalados. Nada que hacer.'
else
  $SUDO yum install -y ${list[*]} ${list_packages[*]}
fi
