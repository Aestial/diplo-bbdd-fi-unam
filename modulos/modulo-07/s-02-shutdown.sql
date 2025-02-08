--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: 

spool /unam/diplo-bd/modulos/modulo-07/s-02-shutdown-jrc-spool.txt

Prompt Pregunta 1
Prompt Conectando a  jrcdiplo3_s1
connect sys/system3@jrcdiplo3_s1 as sysdba 
Prompt Haciendo shutdown
Pause ¿Qué efecto tiene esta instrucción ?: Cierra la PBD
shutdown immediate 

Prompt pregunta 2
col name format a20
set linesize window
alter session  set container=cdb$root;
select con_id,name,open_mode from v$pdbs;
pause Analizar resultados, [Enter] para continuar

Prompt pregunta 3 detener  CDB
connect sys/system3 as sysdba
shutdown immediate

Prompt pregunta 4 , iniciando Nuevamente
startup

prompt Abrir PDBs
alter pluggable database all open;
alter pluggable database all save state;


Prompt apagando spool
spool off
disconnect