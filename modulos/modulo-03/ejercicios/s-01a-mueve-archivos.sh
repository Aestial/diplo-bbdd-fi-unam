#!/bin/bash

#@Autor: Hernandez Vazquez Jaime 
#@Fecha creación: 22/11/2024
#@Descripción: Script para mover archivos, simulando una perdida.

# NOTA: Ejecutar en usuario oracle en shell.

backupDir="/home/oracle/backups/modulo-03"

#Mueve el archivo unicamente si existe
mv_file(){
  file="$1"
  if [ -f "${file}" ]; then
    echo "Moviendo archivo ${file} -> ${backupDir}"
    mv ${file} ${backupDir} 
  fi;
}

echo "Moviendo archivos de la base de datos a directorio de respaldo ${backupDir}"
echo "0. Validando usuario"

if [ "${USER}" != "oracle" ]; then
  echo "El script debe ser ejecutado por el usuario oracle del s.o."
  exit 1;
fi;

echo "1. Deteniendo la instancia"
sqlplus -s  / as sysdba  <<EOF
 shutdown immediate
EOF

echo "2. Creando archivo de respaldo"
mkdir -p "${backupDir}"

echo "3. Moviendo SPFILE y PFILE"
# Agregar ruta del archivo SPFILE (free)
mv_file "${ORACLE_HOME}/dbs/spfilefree.ora"
# Agregar ruta del archivo PFILE (free)
mv_file "${ORACLE_HOME}/dbs/initfree.ora"

echo "4. Moviendo un solo archivo de control"
mv_file "/unam/diplo-bd/disks/d01/app/oracle/oradata/FREE/control01.ctl"

echo "5. Moviendo Redo Logs"
#Para que la instancia falle, todos los archivos REDO deberán moverse al
#directorio de respaldos. Con un solo Redo Log que exista por grupo, la 
#BD puede trabajar. Se tienen que mover los 3 grupos porque no tenemos
#la certeza del grupo que se está empleando a menos que se consulte en
#el diccionario cuál es el grupo actual (esto último se revisa en módulos 
#diferentes)

#--TODO
#grupo 01
mv_file "/unam/diplo-bd/disks/d01/app/oracle/oradata/FREE/redo01a.log" 
mv_file "/unam/diplo-bd/disks/d02/app/oracle/oradata/FREE/redo01b.log" 
mv_file "/unam/diplo-bd/disks/d03/app/oracle/oradata/FREE/redo01c.log" 

#grupo 02
mv_file "/unam/diplo-bd/disks/d01/app/oracle/oradata/FREE/redo02a.log" 
mv_file "/unam/diplo-bd/disks/d02/app/oracle/oradata/FREE/redo02b.log" 
mv_file "/unam/diplo-bd/disks/d03/app/oracle/oradata/FREE/redo02c.log" 

#grupo 03
mv_file "/unam/diplo-bd/disks/d01/app/oracle/oradata/FREE/redo03a.log" 
mv_file "/unam/diplo-bd/disks/d02/app/oracle/oradata/FREE/redo03b.log" 
mv_file "/unam/diplo-bd/disks/d03/app/oracle/oradata/FREE/redo03c.log" 
#TODO--

echo "6. Moviendo data files"

#--TODO
mv_file "${ORACLE_BASE}/oradata/FREE/system01.dbf" 
mv_file "${ORACLE_BASE}/oradata/FREE/users01.dbf" 
#TODO--

echo "Validando respaldo"

files=(
  "control01.ctl"
  "redo01a.log" "redo01b.log" "redo01c.log"
  "redo02a.log" "redo02b.log" "redo02c.log"
  "redo03a.log" "redo03b.log" "redo03c.log"
  "system01.dbf" "users01.dbf"
)

for file in ${files[@]}; do
  echo "Validando ${backupDir}/${file}"
  if ! [ -f "${backupDir}/${file}" ]; then
    echo "ERROR: archivo ${file} no encontrado en ${backupDir}"
    exit 1;
  fi;
done

echo "Mostrando archivos en el directorio de respaldos"
ls -l ${backupDir}
