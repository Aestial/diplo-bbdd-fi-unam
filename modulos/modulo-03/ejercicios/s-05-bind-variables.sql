--@Autor: Hernandez Vazquez Jaime
--@Fecha creación: 23/11/2024
--@Descripción: Probando diferentes sentencias SQL, con y sin binding

Prompt Conectando a PDB como SYS...
connect sys/system2@jrcdiplo_s2 as sysdba

prompt Creando usuario user01
--#TODO
drop user if exists user01 cascade;
create user user01 identified by user01 quota unlimited on users;
grant create session, create table to user01;
--TODO#

Prompt Creando tabla de prueba
--#TODO
drop table if exists user01.test;
create table user01.test(id number) segment creation immediate;
--TODO#

Prompt Limpiando el Shared Pool y el Library Chache
--#TODO
alter system flush shared_pool;
--TODO#

prompt 1. Sentencias SQL con bind variables
set timing on

--#TODO
begin
  for i in 1..100000 loop
    execute immediate 'insert into user01.test (id) values(:ph1)' using i;
  end loop;
commit;
end;
/
--TODO#

Prompt Mostrando datos de la sentencia SQL con bind variables
--#TODO
select executions, loads, parse_calls, disk_reads, buffer_gets, 
  cpu_time/1000 cpu_time_ms, elapsed_time/1000 elapsed_time_ms
from v$sqlstats
where sql_text = 'insert into user01.test (id) values(:ph1)';
--TODO#

prompt 2. Sentencias SQL sin bind variables

--#TODO
begin
  for i in 1..100000 loop
    execute immediate 'insert into user01.test (id) values ('||i||')';
  end loop;
end;
/
--TODO#

Prompt Mostrando datos de la sentencia SQL sin bind variables
--#TODO

select count(*) t_rows, sum(executions) executions, sum(loads) loads, 
  sum(parse_calls) parse_calls, sum(disk_reads) disk_reads, 
  sum(buffer_gets) buffer_gets, sum(cpu_time)/1000 cpu_time_ms, 
  sum(elapsed_time)/1000 elapsed_time_ms
from v$sqlstats
where sql_text like 'insert into user01.test (id) values (%)'
and sql_text <> 'insert into user01.test (id) values (:ph1)';

--TODO#

set timing off

Prompt Limpieza...
--#TODO
connect sys/system2@jrcdiplo_s2 as sysdba
drop user user01 cascade;
--TODO#
