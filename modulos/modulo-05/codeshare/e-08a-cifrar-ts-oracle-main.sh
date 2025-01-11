#!/bin/bash
# Nombre: Jorge Rodríguez C
# Fecha de creación:
# Descripción del script:

echo "1. Validando el usuario del s.o"
#--TODO
usuario=`whoami`
if ! [ "${usuario}" = "oracle" ] ; then
  echo "ERROR: El script se debe ejecutar con el usuario oracle del s.o."
  exit 1;
fi;
#TODO--

keystorePathTde="/etc/oracle/keystores/free/tde"
keystorePathTdeSeps="/etc/oracle/keystores/free/tde_seps"

echo "2. Verificando la existencia del Wallet"
#--TODO
if [[ -f "${keystorePathTde}/cwallet.sso" && 
  -f "${keystorePathTdeSeps}/cwallet.sso"  ]] ; then
  echo "Archivos del TDE Wallet encontrados, se omite la configuración de TDE"
else
  echo "3. Validaciones correctas, creando directorios para crear TDE Wallet"
  echo "Creando directorios, proporcionar el password de root"
  su - root -c "mkdir -p /etc/oracle && chown oracle:oinstall /etc/oracle && chmod 700 /etc/oracle"
  mkdir -p /etc/oracle/keystores/free/tde_seps
  chown -R oracle:oinstall /etc/oracle/
  chmod -R 700 /etc/oracle/

  echo "4. Invocando script sql para configurar TDE"
  sqlplus -s /nolog <<EOF
  @e-08b-configura-tde-oracle.sql
EOF
fi;
#TODO--

echo "=================================================================="
echo "Importante: Una vez que se haya configurado TDE de forma correcta,"
echo "NO borrar los archivos generados dentro de /etc/oracle/keystores/free"
echo "Si se eliminan, la CDB fallará y no hay forma de recuperarse."
echo  "Se tendría que generar una nueva CDB".
echo "=================================================================="
