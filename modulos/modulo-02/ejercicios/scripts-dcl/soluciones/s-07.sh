#@Autor: <Nombre del autor o autores> 
#@Fecha creación: <Fecha de creación> 
#@Descripción: <Breve descripción del contenido del script>

#!/bin/bash

echo "Validando usuario de ejecución"

if [ "${USER}" != "oracle" ]; then
    echo "ERROR: El script debe ser ejecutado por el usuario oracle."
    exit 1;
fi;

echo "1. Moviendo el archivo de passwords a /home/oracle/backups"
#creando directorio de respaldo si no existe
mkdir -p /home/oracle/backups
mv "${ORACLE_HOME}"/dbs/orapwfree /home/oracle/backups

echo "2,3. Creando un nuevo archivo de passwords"
echo "usar el password admin1234#"
orapwd file='${ORACLE_HOME}/dbs/orapwfree' \
  force=Y \
  format=12.2 \
  SYS=password password=admin1234#

echo "comprobando existencia"
ls -l "${ORACLE_HOME}"/dbs/orapwfree
