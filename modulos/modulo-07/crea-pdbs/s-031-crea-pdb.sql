--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: 
clear screen

!mkdir -p /unam/diplo-bd/modulos/modulo-07/e-crea-pdbs
spool /unam/diplo-bd/modulos/modulo-07/e-crea-pdbs/s-031-crea-pdb-jrc-spool.txt
set linesize window
Prompt Creando  PDB a a partir de SEED  (from scratch)

Prompt 1. Iniciando CDB
!sh s-030-start-cdb.sh free system3

Prompt 2. Conectando como SYS en cdb$root
connect sys/system3 as sysdba

Prompt 3. Configurando OMF


Prompt Configurar el parámetro correspondiente para habilitar OMF
alter system set db_create_file_dest='/opt/oracle/oradata' scope=memory;

Prompt 4. Crear una PDB from scratch (desde cero) empleando OMF
create pluggable database jrcdiplo3_s3 
  admin user admin_s3  identified by admin_s3;

Prompt Mostrando los datos de las PDBs con SQL*Plus
col file_name format A60

Prompt Escribir el comando de SQL*Plus que muestra los datos de las PDBs
show pdbs
pause [Enter] para continuar

Prompt 5. Mostrando los datafiles a partir de bda_data_files
select file_id,file_name from dba_data_files;


Prompt Mostrando los datafiles a partir  de cdb_data_files
select file_id,file_name from cdb_data_files;

Prompt Analizar resutados. ¿Qué sucede con los datafiles de la nueva pdb?
pause  [Enter] para continuar

Prompt 6. accediendo a la PDB
alter pluggable database jrcdiplo3_s3 open read write;


Prompt 7. Mostrando datafiles de la CDB desde cdb_data_files
col file_name format A100
select file_id,file_name from cdb_data_files;


Prompt 8. Mostrando datos de las PDBs con comando de SQL*Plus
show pdbs
pause Analizar [enter] para continuar

Prompt Mostrar el id y el nombre del contenedor actual
show con_id
show con_name

Prompt 9. Mostrando datafiles desde la nueva PDB empleando cdb_data_files
alter session set container jrcdiplo3_s3;
select file_id,file_name from cdb_data_files;

pause 10. [Enter] para comenzar con la limpieza ...

prompt Cambiando a cdb$root
alter session set container=cdb$root;
--1. Cerrar PDB
alter pluggable database jrcdiplo3_s3 close;

--2. Hacer una operación de unplug
Prompt Dar permisos de escritura a oracle en la carpeta e-crea-pdbs
!chmod 777 /unam/diplo-bd/modulos/modulo-07/e-crea-pdbs

Prompt Hacer unplug de la PDB
alter  pluggable database jrcdiplo3_s3 unplug 
  into '/unam/diplo-bd/modulos/modulo-07/e-crea-pdbs/jrcdiplo3_s3.xml';

pause Unplug realizado, [Enter] para mostrar el archivo de metadatoss

!cat /unam/diplo-bd/modulos/modulo-07/e-crea-pdbs/jrcdiplo3_s3.xml
pause Analizar XML, [enter] para realizar limpieza 

Prompt Hacer limpieza para el parámetro db_create_file_dest
alter system reset db_create_file_dest scope=memory;

Prompt borrando xml 
!rm /unam/diplo-bd/modulos/modulo-07/e-crea-pdbs/jrcdiplo3_s3.xml

Prompt apagando spool
spool off
disconnect

