--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: 
--
Prompt Creando PDB tipo refreshable

Prompt 1. Creando spool del ejercicio
spool /unam/diplo-bd/modulos/modulo-07/e-crea-pdbs/s-035-crea-pdb-spool.txt

Prompt 2. Conectando como sysdba en contenedor D4
connect sys/system4 as sysdba

Prompt 3.1 Verificando la existencia de la PDB
set serveroutput on 
declare
  v_count number;
begin
  select count(*) into v_count
  from v$pdbs
  where name='JRCDIPLO4_S1';
  if v_count  > 0 then
    select count(*) into v_count 
    from v$pdbs
    where name='JRCDIPLO4_S1'
    and open_mode<>'MOUNTED';
    if v_count >0 then  
      execute immediate 'alter pluggable database jrcdiplo4_s1 close';
    end if;
    execute immediate 'drop pluggable database jrcdiplo4_s1 including datafiles';
  end if;
end;
/

Prompt 3.2 Creando una nueva PDB <iniciales>diplo4_s1 en el contenedor D4
create pluggable database jrcdiplo4_s1 
  admin user admin_s4 identified by admin_s4
  path_prefix = '/opt/oracle/oradata/FREE/'
  file_name_convert = ('pdbseed/','jrcdiplo4_s1/');

prompt 4. Abriendo jrcdiplo4_s1
alter pluggable database jrcdiplo4_s1 open read write;

prompt 5. Crear un common user en cdb$root del contenedor D4 para poder conectarse desde D5
drop user if exists c##jorge_remote cascade;
create user c##jorge_remote identified by jorge container=all;
grant create session,create pluggable database to c##jorge_remote container=all;

Prompt 6. Conectando a cdb$root en el contenedor D5 para crear la liga
Prompt Esta liga se requiere para invocar operaciones de refresh desde D5 hacia D4
Prompt Es decir, la PDB refreshable estará en el contenedor D5
--#TODO
connect sys/system5@free_d5 as sysdba
--TODO#

Prompt 7. crear liga
--#TODO
drop database link if exists clone_link;
create database link clone_link
  connect to c##jorge_remote identified by jorge using 'FREE_D4';
--TODO#

Prompt 8.1 Verificando la existencia de la PDB jrcdiplo5_r1
set serveroutput on 
declare
  v_count number;
begin
  select count(*) into v_count
  from v$pdbs
  where name='JRCDIPLO5_R1';
  if v_count  > 0 then
    select count(*) into v_count 
    from v$pdbs
    where name='JRCDIPLO5_R1'
    and open_mode<>'MOUNTED';
    if v_count >0 then  
      execute immediate 'alter pluggable database jrcdiplo5_r1 close';
    end if;
    execute immediate 'drop pluggable database jrcdiplo5_r1 including datafiles';
  end if;
end;
/

Prompt 8.2 Crear PDB tipo refreshable en D5
create pluggable database jrcdiplo5_r1
  from jrcdiplo4_s1@clone_link
  file_name_convert=(
    '/opt/oracle/oradata/FREE/jrcdiplo4_s1',
    '/opt/oracle/oradata/FREE/jrcdiplo5_r1'
  ) refresh mode manual;

prompt 9. Consultando el último refresh
select  last_refresh_scn
from dba_pdbs
where pdb_name='JRCDIPLO5_R1';
pause Analizar el valor del SCN [enter] para continuar

Prompt 10.1 Crear un tablespace, tabla y un registro en jrcdiplo4_s1
connect sys/system4@jrcdiplo4_s1 as sysdba

create tablespace test_refresh_ts 
 datafile '/opt/oracle/oradata/FREE/jrcdiplo4_s1/test_refresh.dbf'  
   size 10M autoextend on next 1M;

Prompt 10.2 Creando un usuario de prueba en jrcdiplo4_s1
drop user if exists jorge_refresh cascade;
create user jorge_refresh identified by jorge
  default tablespace test_refresh_ts
  quota unlimited on test_refresh_ts;
grant create session, create table to jorge_refresh;

Prompt 10.3. Creando tabla  test, insertando datos
create table jorge_refresh.test(id number);
insert into jorge_refresh.test values(1);
commit;
select * from jorge_refresh.test;

pause  Verificar los datos. [Enter] para conectarse a D5 y hacer refresh de los datos

Prompt 11. conectando a cdb$root en D5
connect sys/system5@free_d5 as sysdba

Prompt 12. Abrir jrcdiplo5_r1 en modo read only
alter pluggable database jrcdiplo5_r1 open read only;

Prompt 13. Consultando los datos esperados en jrcdiplo5_r1
alter session set container = jrcdiplo5_r1;

pause ¿Qué se obtendría  al intentar consultar la tabla ? [Enter] para continuar
-- Respuesta esperada: No va a existir porque falta hacer refresh
select * from jorge_refresh.test;
Pause ¿Qué sucedió ?  [Enter] para continuar y hacer refresh.

Prompt 14. Hacer refresh para la pdb jrcdiplo5_r1. El refresh se realiza desde cdb$root
alter session set container=cdb$root;
---Para hacer refresh debemos cerrar la PDB
alter pluggable database jrcdiplo5_r1 close immediate;
--Habilitar OMF para indicar la ubicación del datafile del TS a sincronizar
alter system set db_create_file_dest='/opt/oracle/oradata'
  scope=memory;
--hacer refresh
alter pluggable database jrcdiplo5_r1 refresh;


Prompt 15. Consultando datos nuevamente 
pause ¿qué se esperaría ?[Enter] para continuar
alter pluggable database jrcdiplo5_r1 open read only;

alter session set container = jrcdiplo5_r1;
select * from jorge_refresh.test;


prompt 16. Consultando el último refresh
select last_refresh_scn
from dba_pdbs
where pdb_name='JRCDIPLO5_R1';

Pause 17. Analizar resultados, [Enter] para realizar limpieza

Prompt eliminando PDB jrcdiplo5_r1
alter session set container=cdb$root;
alter pluggable database jrcdiplo5_r1 close immediate;
drop pluggable database jrcdiplo5_r1 including datafiles;

Prompt eliminar liga
drop database link clone_link;

Prompt Limpieza en D4
connect sys/system4 as sysdba

Prompt eliminando common user 
drop user  c##jorge_remote cascade;

Prompt cerrando spool
spool of 
disconnect



