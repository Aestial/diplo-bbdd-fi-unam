--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción:

whenever sqlerror exit rollback

connect sys/system2 as sysdba
Prompt mostrar el valor del  tamaño del bloque por default.
show parameter db_block_size

Prompt creando tabla para provocar row chaining
connect jorge05/jorge

--cada registro requiere más de 8Ks para poder almacenarse.
create table t03_row_chaining(
  id number(10,0) constraint t03_row_chaining_pk primary key,
  c1 char(2000) default 'A',
  c2 char(2000) default 'B',
  c3 char(2000) default 'C',
  c4 char(2000) default 'D',
  c5 char(2000) default 'E'
);

insert into t03_row_chaining(id) values (1);
commit;

Prompt actualizando estadísticas
analyze table t03_row_chaining compute statistics;

Prompt consultando metadatos
set linesize window
select tablespace_name,pct_free,pct_used,num_rows,blocks,empty_blocks,
  avg_space/1024 as avg_space_kb, chain_cnt,avg_row_len/1024 as avg_row_len_kb
from user_tables where table_name='T03_ROW_CHAINING';

Pause [Enter] para continuar con el proceso de creación del Tablespace

Prompt create tablespace con un tamaño de bloque diferente.
connect sys/system2 as sysdba

alter system set db_16k_cache_size = 16m scope=memory;

create tablespace dip_m05_01
  blocksize 16k
  datafile '/u01/app/oracle/oradata/JRCDIP02/dip_m05_01.dbf' size 20m
  extent management local uniform size 1M;

Prompt otorgando quota.
alter user jorge05 quota unlimited on dip_m05_01;

Prompt moviendo datos de la tabla al nuevo tablespace
connect jorge05/jorge
alter table t03_row_chaining move tablespace dip_m05_01;

Prompt reconstruir índices ya que se invalidan al mover de TS
alter index t03_row_chaining_pk rebuild;

Prompt calculando estadísticas nuevamente
analyze table t03_row_chaining compute statistics;

Prompt consultando metadatos nuevamente
set linesize window
select tablespace_name,pct_free,pct_used,num_rows,blocks,empty_blocks,
  avg_space/1024 as avg_space_kb, chain_cnt,avg_row_len/1024 as avg_row_len_kb
from user_tables where table_name='T03_ROW_CHAINING';

--Eliminar la tabla y el TS  para evitar configurar de forma permanente
--el pool de 16K
drop table t03_row_chaining;

connect sys/system2 as sysdba
drop tablespace dip_m05_01;

exit;

/*
Get DDL 
set heading off;
set echo off;
Set pages 999;
set long 90000;
select dbms_metadata.get_ddl('TABLE','TEST','TEST') from dual;
*/
