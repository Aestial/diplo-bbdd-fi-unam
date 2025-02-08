--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: 

Prompt 1. Creando el spool del ejercicio 
!mkdir -p /unam/diplo-bd/modulos/modulo-07  
spool /unam/diplo-bd/modulos/modulo-07/s-01-consulta-cdb-jrc-spool.txt

set linesize window
col pdb_name format a30
col name format a30
col open_time format a40


prompt 2.  Autenticando en cdb$root como sysdba
connect sys/system3 as sysdba

Prompt 3.1 Consulta en v$database desde cdb$root
select dbid,name,cdb,con_id,con_dbid from v$database;

prompt 3.2 Consulta en v$database desde jrcdiplo3_s1
connect sys/system3@jrcdiplo3_s1 as sysdba 
select dbid,name,cdb,con_id,con_dbid from v$database;

prompt 3.3 Consulta en v$database, desde jrcdiplo3_s2
connect sys/system3@jrcdiplo3_s2 as sysdba 
select dbid,name,cdb,con_id,con_dbid from v$database;

pause Analizar resultados de las 3 consultas, [enter] para continuar

prompt 4.1 Consulta en root - dba_pdbs
connect sys/system3 as sysdba 
select pdb_id,pdb_name,dbid,status from dba_pdbs;

prompt 4.2 Consulta en jrcdiplo3_s2 - dba_pdbs
connect sys/system3@jrcdiplo3_s2 as sysdba 
select pdb_id,pdb_name,dbid,status from dba_pdbs;
pause Analizar resultados [enter] para continuar

prompt 5.1 Consulta en root - v$pdbs 
connect sys/system3 as sysdba 
select  con_id,name,open_mode,open_time from v$pdbs;


prompt 5.2 Consulta en jrcdiplo3_s1 - v$pdbs
connect sys/system3@jrcdiplo3_s1 as sysdba 
select  con_id,name,open_mode,open_time from v$pdbs;

prompt 5.3 Consulta en jrcdiplo3_s2 - v$pdbs
connect sys/system3@jrcdiplo3_s2 as sysdba 
select  con_id,name,open_mode,open_time from v$pdbs;
pause Analizar resultados [enter] para continuar

prompt 6.1 Consulta desde root empleando alter session
alter session set container=cdb$root;
show con_id
show con_name


prompt 6.2 Consulta desde jrcdiplo3_s1 empleando alter session
alter session set container=jrcdiplo3_s1;
show con_id
show con_name

prompt 6.3 Consulta desde jrcdiplo3_s2 empleando alter session
alter session set container=jrcdiplo3_s2;
show con_id
show con_name
pause Analizar resultados [enter] para continuar

Prompt 7.1 Conectando a jrcdiplo3_s1, creando usuario y tabla de prueba
alter session set container=jrcdiplo3_s1;
drop user if exists jorge07 cascade;
create user jorge07 identified by jorge quota unlimited on users;
grant create session, create table to jorge07;
create table jorge07.test(id number);

Prompt 7.2 Conectando a jrcdiplo3_s2, creando usuario y tabla de prueba
alter session set container=jrcdiplo3_s2;
drop user if exists jorge07 cascade;
create user jorge07 identified by jorge quota unlimited on users;
grant create session, create table to jorge07;
create table jorge07.test(id number);

prompt 8. Creando un nuevo registro en la pdb s1 para la tabla jorge07.test
alter session set container=jrcdiplo3_s1;
--se inicia una txn
insert into jorge07.test values(1);
Prompt consultando datos de la transacción
select xid,con_id,status,start_time from v$transaction;

Prompt 9.1 Conectando a jrcdiplo3_s2 sin hacer commit de esta transacción
pause ¿Se podrá hacer switch? [enter] para continuar
alter session set container=jrcdiplo3_s2;
pause ¿fue posible ? [enter] para continuar

prompt 9.2 Intentando insertar en la tabla ¿Se genera otra transacción?
insert into jorge07.test values(1);
pause ¿Fue posible ? [enter] para continuar

prompt 9.3 Conectando nuevamente a jrcdiplo3_s1 ¿qué sucedió con la txn?
alter session set container=jrcdiplo3_s1;
select xid,con_id,status,start_time from v$transaction;
Prompt consultando datos de la tabla
select * from jorge07.test;

prompt 10.1 Consulta en dba_objects en root 
alter session set container=cdb$root;
select count(*), oracle_maintained 
from  dba_objects
group by oracle_maintained;


prompt 10.2 Consulta dba_objects en jrcdiplo3_s1 
alter session set container=jrcdiplo3_s1;
select count(*), oracle_maintained 
from  dba_objects
group by oracle_maintained;

pause Analizar resultados [enter] para continuar

prompt 11 Limpieza
alter session set container=jrcdiplo3_s1;
drop user jorge07 cascade;
alter session set container=jrcdiplo3_s2;
drop user jorge07 cascade;
pause [enter] para continuar


prompt 12. consulta del ejercicio 1  MD 02-conceptos-basicos.md

prompt  Consulta en dba_objects en root  despues de eliminar al usuario
alter session set container=cdb$root;
select count(*), oracle_maintained 
from  dba_objects
group by oracle_maintained;


prompt 10.2 Consulta dba_objects en jrcdiplo3_s1 
alter session set container=jrcdiplo3_s1;
select count(*), oracle_maintained 
from  dba_objects
group by oracle_maintained;




Prompt apagando spool
spool off
disconnect