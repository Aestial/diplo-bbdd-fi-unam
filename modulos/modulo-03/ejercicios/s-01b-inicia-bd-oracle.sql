--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

Prompt Usuario que ejecuta el script:
!echo " ===> Usuario del S.O. para ejecutar: ${USER}"
Pause "Verificar que el usuario sea oracle. Ctrl-C Cancelar, Enter para continuar"

Prompt 1.  Autenticando como sysdba en cdb$root
connect sys/system2 as sysdba

define p_backup_dir='/home/oracle/backups/modulo-03'
!mkdir -p &p_backup_dir

Prompt 2. Intentando iniciar instancia modo nomount
startup nomount

Pause [Enter para corregir y reintentar]
Prompt restaurando archivos de parámetros
!mv  &p_backup_dir/spfilefree.ora  $ORACLE_HOME/dbs
!mv  &p_backup_dir/initfree.ora  $ORACLE_HOME/dbs

Prompt Reintentando el inicio en modo nomount
--#TODO
startup nomount
--TODO#
pause [¿ Se corrigió el error? Enter para continuar]


Prompt 3. Intentando pasar al modo mount
--#TODO
alter database mount;
--TODO#

pause [Enter para corregir y reintentar]
--#TODO
Prompt restaurando el archivo de control
!mv &p_backup_dir/control01.ctl /unam/diplo-bd/disks/d01/app/oracle/oradata/FREE/
--#TODO

Prompt Reintentando pasar al modo mount
--#TODO
alter database mount;
--TODO#
Pause [¿ Se corrigió el error? Enter para continuar]

prompt 4. Intentar pasar al modo open
--#TODO
alter database open;
--TODO#
pause [Enter para corregir y reintentar]
--#TODO
prompt Restaurando datafile para el tablespace system 
!mv &p_backup_dir/system01.dbf  $ORACLE_BASE/oradata/FREE/
--#TODO

prompt intentando abrir nuevamente 
--#TODO
alter database open;
--TODO#

pause [¿Se corrigió el error? Enter para restaurar datafile del TS users]
--#TODO
!mv &p_backup_dir/users01.dbf  $ORACLE_BASE/oradata/FREE/
--TODO#

prompt intentando abrir nuevamente 
--#TODO
alter database open;
--TODO#

pause [¿Se corrigió el error?, Revisar alert Log!, Enter para corregir]

--#TODO
prompt restaurando redo logs 
-- grupo 1
!mv &p_backup_dir/redo01a.log  /unam/diplo-bd/disks/d01/app/oracle/oradata/FREE/
!mv &p_backup_dir/redo01b.log  /unam/diplo-bd/disks/d02/app/oracle/oradata/FREE/
!mv &p_backup_dir/redo01c.log  /unam/diplo-bd/disks/d03/app/oracle/oradata/FREE/

-- grupo 2
!mv &p_backup_dir/redo02a.log  /unam/diplo-bd/disks/d01/app/oracle/oradata/FREE/
!mv &p_backup_dir/redo02b.log  /unam/diplo-bd/disks/d02/app/oracle/oradata/FREE/
!mv &p_backup_dir/redo02c.log  /unam/diplo-bd/disks/d03/app/oracle/oradata/FREE/

-- grupo 3
!mv &p_backup_dir/redo03a.log  /unam/diplo-bd/disks/d01/app/oracle/oradata/FREE/
!mv &p_backup_dir/redo03b.log  /unam/diplo-bd/disks/d02/app/oracle/oradata/FREE/
!mv &p_backup_dir/redo03c.log  /unam/diplo-bd/disks/d03/app/oracle/oradata/FREE/
--#TODO

Prompt 5. Intentando iniciar nuevamente en modo OPEN
Prompt requiere autenticar y volver a iniciar
--#TODO
connect sys/system2 as sysdba
startup open; 
--#TODO

prompt 6. Mostrando status
--#TODO
select status from v$instance;
--TODO#

Prompt 7. Comprobando que los archivos en el directorio backup hayan sido restaurados
Prompt la carpeta debe estar vacía
--#TODO
!ls -l &p_backup_dir
--TODO#

Pause [¿La Base ha regresado a la normalidad ? Enter para terminar]
