--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción:

whenever sqlerror exit rollback

define pdb=jrcdiplo_s2

Prompt 1. Creando spool del ejercicio
spool jrc-e-07-tablespace-usr-spool.txt

Prompt 2.  Conectar como sysdba en cdb$root
connect sys/system2 as sysdba

set linesize window
col default_temp_ts format a30
col default_permanent_ts format a30
col undo_ts format a30
col tablespace_name format a30
col username  format a30

Prompt 3. Mostrando datos de los tablespaces empleados por todos los usuarios
--#TODO

--TODO#
pause Analizar resultados, [Enter] para continuar


Prompt 4. Mostrando datos de los tablespaces a través de user_users (jorge05)
connect jorge05/jorge@&pdb
--#TODO

--TODO#
pause Analizar resultados, [Enter] para continuar

Prompt 5. Mostrando quotas de almacenamiento para los usuarios nivel cdb$root
Prompt conectando como sysdba en cdb$root
connect sys/system2 as sysdba 
--#TODO

--TODO#
pause Analizar resultados, [Enter] para continuar

Prompt 6. Mostrar los datos del ts temporal
--#TODO

--TODO#
pause Analizar resultados, [Enter] para continuar

--Instrucción para cambiar el ts temporal:
--#TODO
--
--TODO#

Prompt Listo
spool off
disconnect