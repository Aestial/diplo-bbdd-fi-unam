--@Autor:   Hernandez Vazquez Jaime
--@Fecha creación: 11/01/2025
--@Descripción:

whenever sqlerror exit rollback

spool jhv-e-09-tablespaces-spool.txt

-- Actualizar con el nombre de la PDB
define pdb='jhvdiplo_s2'
define syslogon='sys/system2@&pdb as sysdba'
define t_user='m05_store_user'
define t_userlogon='&t_user/&t_user@&pdb'

set linesize window

Prompt conectando como sys

connect &syslogon

Prompt Creando tablespaces. Nota: Actualizar nombres de PDBs según corresponda

Prompt Ejercicio 1 crear TS m05_store_tbs1
-------------------------------------------
drop tablespace if exists m05_store_tbs1 including contents and datafiles;
--#TODO
create tablespace m05_store_tbs1
  datafile '/opt/oracle/oradata/FREE/jhvdiplo_s2/m05_store_tbs01.dbf' 
  size 30m
  extent management local autoallocate
  segment space management auto;
--TODO#

Prompt Ejercicio 2 crear TS  m05_store_multiple_tbs
--------------------------------------------------
drop tablespace if exists m05_store_multiple_tbs including contents and datafiles;
--#TODO
create tablespace m05_store_multiple_tbs
  datafile
    '/opt/oracle/oradata/FREE/jhvdiplo_s2/m05_store_tbs_multiple_01.dbf' size 15m,
    '/opt/oracle/oradata/FREE/jhvdiplo_s2/m05_store_tbs_multiple_02.dbf' size 15m,
    '/opt/oracle/oradata/FREE/jhvdiplo_s2/m05_store_tbs_multiple_03.dbf' size 15m
  extent management local autoallocate
  segment space management auto;
--TODO#

Prompt Ejercicio 3 crear TS m05_store_tbs_custom
-------------------------------------------------
drop tablespace if exists m05_store_tbs_custom including contents and datafiles;
--#TODO
create tablespace m05_store_tbs_custom
  datafile '/opt/oracle/oradata/FREE/gbldiplo_s2/m05_store_tbs_custom_01.dbf'
  size 15m
  reuse
  autoextend on next 2m maxsize 40m
  nologging 
  blocksize 8 k
  offline
extent management local uniform size 64k
segment space management auto;
--TODO#

Prompt Ejercicio 4 Consultar tablespaces creados
----------------------------------------------
select tablespace_name,status,contents
from dba_tablespaces;

Pause Analizar resultados, [enter] para continuar

Prompt Ejercicio 5  crear usuario m05_store_user
---------------------------------------------------
drop user if exists &t_user cascade;
create user &t_user identified by &t_user
  quota unlimited on m05_store_tbs1
  default tablespace m05_store_tbs1;
grant create session, create table, create procedure to &t_user;


Prompt Ejercicio 6 - crear tabla m05_store_data con el usuario m05_store_user
-----------------------------------------------------------------------------

connect &t_userlogon
drop table if exists store_data;
create table store_data(
  c1 char(1024),
  c2 char(1024)
) segment creation deferred;


Prompt ejercicio 7 - Programa que llena un TS 
-----------------------------------------------
--#TODO
create or replace procedure sp_e6_reserva_extensiones is
  v_extensiones number;
  v_total_espacio number;
begin 
  v_extensiones := 0;
  loop 
    begin 
      execute immediate 'alter table store_data allocate extent';
    exception
      when others then
        if sqlcode = -1653 then
          dbms_output.put_line('===> Sin espacio en TS');
          dbms_output.put_line('===> Código error:  '||sqlcode);
          dbms_output.put_line('===> Mensaje error: '||sqlerrm);
          dbms_output.put_line('===> '||dbms_utility.format_error_backtrace);
          exit;
        end if;
    end;
  end loop;
  --total espacio asignado
  select sum(bytes)/1024/1024, count(*) into v_total_espacio,v_extensiones
  from user_extents
  where segment_name='STORE_DATA';
  dbms_output.put_line('==> Total de extensiones reservadas: '||v_extensiones);
  dbms_output.put_line('==> Total espacio reservado (MB):    '||v_total_espacio);
end;
/
show errors
--TODO#

Prompt ejecutando procedimiento
set serveroutput on 
exec sp_e6_reserva_extensiones

Pause Analizar resultados,[Enter] para continuar


Prompt Ejercicio 8 modificar TS para poder almacenar.
------------------------------------------------------

connect &syslogon
--#TODO
alter tablespace m05_store_tbs1
  add datafile '/opt/oracle/oradata/FREE/jhvdiplo_s2/m05_store_tbs02.dbf'
    size 10m;
--TODO#

Prompt  9 Ejecutar nuevamente el programa para confirmar  resultados.
----------------------------------------------------------------
connect &t_userlogon
set serveroutput on
--#TODO
exec sp_e6_reserva_extensiones;
--TODO#
Pause Analizar nuevamente los resultados,[Enter] para continuar


Prompt Ejercicio 10 Consultar tablespaces
------------------------------------------

connect &syslogon
--#TODO
select t.tablespace_name, count(s.tablespace_name) as total_segmentos
from dba_tablespaces t
left outer join dba_segments s
on t.tablespace_name = s.tablespace_name
group by t.tablespace_name
order by 2 desc;
--TODO#

Pause Analizar los resultados,[Enter] para continuar

Prompt  Ejecutando datos de los data files 
------------------------------------------
@e-10-data-files.sql


Prompt - Limpieza
----------------------------------------------

connect &syslogon

--eliminando ts y usuario
drop tablespace if exists m05_store_tbs1 including contents and datafiles;
drop tablespace if exists m05_store_multiple_tbs including contents and datafiles;
drop tablespace if exists m05_store_tbs_custom including contents and datafiles;
drop user if exists &t_user cascade;

Prompt listo!
spool off
disconnect