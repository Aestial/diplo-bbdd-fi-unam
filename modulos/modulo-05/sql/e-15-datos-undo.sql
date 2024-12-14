define syslogon='sys/system2 as sysdba'
define test_user='jorge05'
set verify off
set linesize window

connect &syslogon

Prompt 1. Mostrando tablespace undo en uso
-------------------------------------------

show parameter undo_tablespace

Pause [enter] para continuar


Prompt 2. creando un nuevo tablespace
--------------------------------------

set serveroutput on
declare
  v_count number;
begin
  select count(*) into v_count 
  from dba_tablespaces
  where tablespace_name='UNDOTBS2';
  if v_count > 0 then 
    dbms_output.put_line('Eliminando unddotbs2');
    execute immediate 
      'alter system set undo_tablespace=''undotbs1'' scope=memory';
    execute immediate 'drop tablespace undotbs2 including contents and datafiles';
  end if;
end;
/

create undo tablespace undotbs2
  datafile '/u01/app/oracle/oradata/JRCDIP02/undotbs_2.dbf'
  size 30m 
  autoextend off
  extent management local autoallocate;


Prompt 3. Configurando el nuevo TS undo
---------------------------------------

alter system set undo_tablespace='undotbs2' scope=memory;

Prompt 4. Mostrar nuevamente el valor del parámetro undo_tablespace
-------------------------------------------------------------------

show parameter undo_tablespace

Pause Analizar resultado, [enter] Para continuar

Prompt 5. Mostrando estadísticas de los datos Undo
--------------------------------------------------

alter session set nls_date_format ='dd-mm-yyyy hh24:mi:ss';

select * from (
  select begin_time, end_time, undotsn, undoblks, txncount, maxqueryid,
    maxquerylen,activeblks, unexpiredblks, expiredblks, tuned_undoretention,
    tuned_undoretention/60 tuned_undo_min
  from v$undostat order by begin_time desc
) where rownum <=20;

Pause 6. Analizar resultados, contestar preguntas, [enter] para continuar.
------------------------------------------------------------------------

Prompt 7. Mostrando nombres de los TS
-------------------------------------

select * from (
  select u.begin_time, u.end_time, u.undotsn, t.name
  from v$undostat u, v$tablespace t
  where t.ts# = u.undotsn order by u.begin_time desc
) where rownum <=20;

Pause Analizar resultados, [enter] para continuar

Prompt 8. Mostrar los datos del nuevo TS Undo
---------------------------------------------

select  df.tablespace_name, df.blocks as total_bloques, 
  sum(f.blocks) bloques_libres, round(sum(f.blocks)/df.blocks*100,2)
  as "%_BLOQUES_LIBRES"
from dba_data_files df, dba_free_space f
where df.tablespace_name = f.tablespace_name
and df.tablespace_name = 'UNDOTBS2'
group by df.tablespace_name, df.blocks;

Pause Analizar resultados, [enter] para continuar

Prompt 9.  Creación y poblado de tabla en el esquema del usuario del modulo.
-------------------------------------

declare
  v_count number;  
begin
  --check sequence
  select count(*) into v_count
  from all_sequences
  where sequence_name='SEC_RANDOM_STR_2'
  and  sequence_owner =upper('&test_user');
  if v_count >  0  then
    execute immediate 'drop sequence &test_user..sec_random_str_2';
  end if;
  --check table
  select count(*) into v_count
  from all_tables where table_name='RANDOM_STR_2'
  and owner=upper('&test_user');
  if v_count > 0 then 
    execute immediate 'drop table &test_user..random_str_2 purge';
  end if;
end;
/

create table &test_user..random_str_2 (
  id number,
  cadena varchar2(1024)
) nologging;

create sequence &test_user..sec_random_str_2;

Prompt secuencias actuales de redo logs
select group#,thread#,sequence#,bytes/1024/1024 size_mb
from v$log;

Pause [enter] para comenzar con el poblado de la tabla

declare
begin
  for v_index in 1..50000 loop
    insert /*+ append */ into &test_user..random_str_2 
      values(&test_user..sec_random_str_2.nextval,dbms_random.string('X',1024));
  end loop;
end;
/
commit;

Prompt secuencias actuales de redo logs (comparar con la salida anterior)
select group#,thread#,sequence#,bytes/1024/1024 size_mb
from v$log;

Pause Analizar salida, [enter] para continuar

Prompt mostrando nuevamente datos de v$undostat y bloques libres
select * from (
  select begin_time, end_time, undotsn, undoblks, txncount, maxqueryid,
    maxquerylen,activeblks, unexpiredblks, expiredblks, tuned_undoretention,
    tuned_undoretention/60 tuned_undo_min
  from v$undostat order by begin_time desc
) where rownum <=20;

select  df.tablespace_name, df.blocks as total_bloques, 
  sum(f.blocks) bloques_libres, round(sum(f.blocks)/df.blocks*100,2)
  as "%_BLOQUES_LIBRES"
from dba_data_files df, dba_free_space f
where df.tablespace_name = f.tablespace_name
and df.tablespace_name = 'UNDOTBS2'
group by df.tablespace_name, df.blocks;

Pause Revisar resultados, [enter] para continuar 

Prompt 10. Replicar error al ejecutar sentencias DML

Prompt borrar 1-10,000
delete from &test_user..random_str_2 where id between 1 and 10000;

select  df.tablespace_name, df.blocks as total_bloques, 
  sum(f.blocks) bloques_libres, round(sum(f.blocks)/df.blocks*100,2)
  as "%_BLOQUES_LIBRES"
from dba_data_files df, dba_free_space f
where df.tablespace_name = f.tablespace_name
and df.tablespace_name = 'UNDOTBS2'
group by df.tablespace_name, df.blocks;

Pause Analizar, [enter] para continuar

Prompt borrar 10,001-20,000
delete from &test_user..random_str_2 where id between 10001 and 20000;

select  df.tablespace_name, df.blocks as total_bloques, 
  sum(f.blocks) bloques_libres, round(sum(f.blocks)/df.blocks*100,2)
  as "%_BLOQUES_LIBRES"
from dba_data_files df, dba_free_space f
where df.tablespace_name = f.tablespace_name
and df.tablespace_name = 'UNDOTBS2'
group by df.tablespace_name, df.blocks;

Pause Analizar, [enter] para continuar

Prompt borrar 20,001-30,000
delete from &test_user..random_str_2 where id between 20001 and 30000;

select  df.tablespace_name, df.blocks as total_bloques, 
  sum(f.blocks) bloques_libres, round(sum(f.blocks)/df.blocks*100,2)
  as "%_BLOQUES_LIBRES"
from dba_data_files df, dba_free_space f
where df.tablespace_name = f.tablespace_name
and df.tablespace_name = 'UNDOTBS2'
group by df.tablespace_name, df.blocks;

Pause Analizar, [enter] para continuar

Prompt borrar 30,001-40,000
delete from &test_user..random_str_2 where id between 30001 and 40000;

select  df.tablespace_name, df.blocks as total_bloques, 
  sum(f.blocks) bloques_libres, round(sum(f.blocks)/df.blocks*100,2)
  as "%_BLOQUES_LIBRES"
from dba_data_files df, dba_free_space f
where df.tablespace_name = f.tablespace_name
and df.tablespace_name = 'UNDOTBS2'
group by df.tablespace_name, df.blocks;

Pause Analizar, [enter] para continuar

Prompt borrar 40,001-50,000
delete from &test_user..random_str_2 where id between 40001 and 50000;

select  df.tablespace_name, df.blocks as total_bloques, 
  sum(f.blocks) bloques_libres, round(sum(f.blocks)/df.blocks*100,2)
  as "%_BLOQUES_LIBRES"
from dba_data_files df, dba_free_space f
where df.tablespace_name = f.tablespace_name
and df.tablespace_name = 'UNDOTBS2'
group by df.tablespace_name, df.blocks;

Pause Analizar, [enter] para continuar

Prompt mostrando nuevamente datos de v$undostat y bloques libres
select * from (
  select begin_time, end_time, undotsn, undoblks, txncount, maxqueryid,
    maxquerylen,activeblks, unexpiredblks, expiredblks, tuned_undoretention,
    tuned_undoretention/60 tuned_undo_min
  from v$undostat order by begin_time desc
) where rownum <=20;

Prompt haciendo rollback;
rollback;