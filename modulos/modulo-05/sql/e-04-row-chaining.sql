--@Autor:   Jaime Hernandez Vazquez
--@Fecha creación:  14/12/2024
--@Descripción: Costos del encadenamiento de bloques.

whenever sqlerror exit rollback

connect sys/system2@jhvdiplo_s2 as sysdba

Prompt mostrar el valor del  tamaño del bloque por default.
show parameter db_block_size

Prompt conectando como user05pdb para generar una tabla grande
connect jaime05pdb/jaime@jhvdiplo_s2 as sysdba

Prompt creando tabla para provocar row chaining
declare begin
   execute immediate 'drop table t03_row_chaining';
exception
   when others then
      null;
end;
/

--cada registro requiere más de 8Ks para poder almacenarse.
create table t03_row_chaining(
  id number(10,0) constraint t03_row_chaining_pk primary key,
  c1 char(2000) default 'A',
  c2 char(2000) default 'B',
  c3 char(2000) default 'C',
  c4 char(2000) default 'D',
  c5 char(2000) default 'E'
);

Prompt insertando un primer registro
insert into t03_row_chaining(id) values (1);
commit;

Prompt mostrando el tamaño de la columna c1
--#TODO
select length(c1) from t03_row_chaining where id=1;
--#TODO

Prompt actualizando estadísticas
analyze table t03_row_chaining compute statistics;

Prompt consultando metadatos
set linesize window
--##TODO
select tablespace_name,pct_free,pct_used,num_rows,blocks,empty_blocks,
  avg_space/1024 as avg_space_kb, chain_cnt,avg_row_len/1024 as avg_row_len_kb
from user_tables where table_name='T03_ROW_CHAINING';
--##TODO

Pause Analizar, presionar [Enter] parar corregir problema

Pause [Enter] para continuar con el proceso de creación del Tablespace

Prompt Creando un nuevo tablespace con bloques de 16K, conectando como SYS
connect sys/system2 as sysdba

--Tamanio de todo el pool
--##TODO
alter system set db_16k_cache_size = 16m scope=memory;
--##TODO

begin
--##TODO
  execute immediate 'drop tablespace dip_m05_01 including contents and datafiles';
exception
  when others then
    null;
--##TODO
end;
/

Prompt create tablespace con un tamaño de bloque diferente.
--##TODO
create tablespace dip_m05_01
  blocksize 16k
  -- TODO: CHECAR SIGUIENTE RUTA
  datafile '/u01/app/oracle/oradata/JHVDIP02/dip_m05_01.dbf' size 20m
  extent management local uniform size 1M;
--##TODO


Prompt otorgando quota de almacenamiento al usuario jaime05 en el nuevo tablespace.
--##TODO
connect sys/system2@jhvdiplo_s2 as sysdba
alter user jaime05pdb default quota unlimited on dip_m05_01;
--##TODO

Prompt moviendo datos de la tabla al nuevo tablespace, conectando como jaime05pdb
--##TODO
connect jaime05pdb/jaime@jhvdiplo_s2
alter table t03_row_chaining move tablespace dip_m05_01;
--##TODO

Prompt reconstruir índices ya que se invalidan al mover de TS
alter index t03_row_chaining_pk rebuild;

Prompt calculando estadísticas nuevamente
analyze table t03_row_chaining compute statistics;

Prompt consultando metadatos nuevamente
set linesize window
select tablespace_name,pct_free,pct_used,num_rows,blocks,empty_blocks,
  avg_space/1024 as avg_space_kb, chain_cnt,avg_row_len/1024 as avg_row_len_kb
from user_tables where table_name='T03_ROW_CHAINING';

Pause Analizar y presionar [Enter] para continuar

Prompt  Mostrando el DDL de la tabla modificada

set heading off;
set echo off;
Set pages 999;
set long 90000;
--##TODO
select dbms_metadata.get_ddl(
  'TABLE',
  'TEST',
  'TEST'
) from dual;
--##TODO

Pause Prueba terminada, presionar [Enter] para hacer limpieza

Prompt eliminando tabla t03_row_chaining
--Eliminar la tabla y el TS  para evitar configurar de forma permanente
--el pool de 16K
drop table t03_row_chaining;

Prompt  Eliminando TS 
connect sys/system2 as sysdba

drop tablespace dip_m05_01 including contents and datafiles;

exit;

-- NOTA: scripts con ejecutado posiblemente con errores.