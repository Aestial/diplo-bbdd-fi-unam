--@Autor:          
--@Fecha creación:  
--@Descripción:

whenever sqlerror exit rollback

define pdb=gbldiplo_s2

Prompt 1. Creando spool del ejercicio
spool gbl-e-04-row-chaining-spool.txt

Prompt 2. Conectando como sysdba en &pdb
connect sys/system2@&pdb as sysdba

Prompt 3.  Mostrar el valor del  tamaño del bloque por default.
--#TODO
show parameter db_block_size
--TODO#
pause Analizar resultados, [Enter] para continuar

Prompt 4. Conectar con  el usuario <nombre>05 en &pdb 
create user betzabe05 identified by betzabe quota unlimited on users;
grant create table, create session  to betzabe05;

connect betzabe05/betzabe@&pdb

Prompt 5.  Creando tabla para provocar row chaining
Prompt Cada registro requiere más de 8Ks para poder almacenarse.
--#TODO
drop table if exists t03_row_chaining;
create table t03_row_chaining(
  id number(10,0) constraint t03_row_chaining_pk primary key,
  c1 char(2000) default 'A',
  c2 char(2000) default 'B',
  c3 char(2000) default 'C',
  c4 char(2000) default 'D',
  c5 char(2000) default 'E'
);
--TODO#

Prompt 6. Insertando un registro 
--#TODO
insert into t03_row_chaining(id) values (1);
commit;
--TODO#

Prompt 7. Actualizando estadísticas
--#TODO
analyze table t03_row_chaining compute statistics;
--TODO#

Prompt 8. Consultando metadatos
set linesize window
--#TODO
select tablespace_name,pct_free,pct_used,num_rows,blocks,empty_blocks,
  avg_space/1024 as avg_space_kb, chain_cnt,avg_row_len/1024 as avg_row_len_kb
from user_tables 
where table_name='T03_ROW_CHAINING';
--TODO#
Pause Analizar resultados, [Enter] para continuar con el proceso de creación del Tablespace

Prompt 9. Conectando como sysdba en root para modificar el parámetro db_16k_cache_size
connect sys/system2 as sysdba

Prompt 10. Asignar memoria al DB Buffer caché para bloques de 16K
--#TODO
alter system set db_16k_cache_size = 16m scope=memory;
--TODO#


Prompt 11. Creando un tablespace con un tamaño de bloque diferente en &pdb
--#TODO
alter session set container=&pdb;
drop tablespace if exists diplo_m05_01 including contents and datafiles;
create tablespace diplo_m05_01
  blocksize 16k
  datafile '/opt/oracle/oradata/FREE/gbldiplo_s2/diplo_m05_01.dbf' size 20m
  extent management local uniform size 1M;
--TODO#

Prompt 12. Otorgando cuota de almacenamiento al usuario <nombre>05
--#TODO
alter user betzabe05 quota unlimited on diplo_m05_01;
--TODO#

Prompt 13. Moviendo datos de la tabla al nuevo tablespace
connect betzabe05/betzabe@&pdb
--#TODO
alter table t03_row_chaining move tablespace diplo_m05_01;
--TODO#

Prompt 14. Reconstruir índices ya que se invalidan al mover de TS
--#TODO
alter index t03_row_chaining_pk rebuild;
--TODO#

Prompt 15. Calculando estadísticas nuevamente
--#TODO
analyze table t03_row_chaining compute statistics;
--TODO#

Prompt 16. Consultando metadatos nuevamente
set linesize window
--#TODO
select tablespace_name,pct_free,pct_used,num_rows,blocks,empty_blocks,
  avg_space/1024 as avg_space_kb, chain_cnt,avg_row_len/1024 as avg_row_len_kb
from user_tables where table_name='T03_ROW_CHAINING';
--TODO#
Pause Analizar resultados, [enter] para continuar

-- Aplicar limpieza 

Prompt 17. Eliminar la tabla y el TS  para evitar configurar de forma permanente
Prompt el pool de 16K
drop table t03_row_chaining;

Prompt Eliminando tablespace 
connect sys/system2@&pdb as sysdba
--#TODO
drop tablespace diplo_m05_01 including contents and datafiles;
--TODO#

Prompt Listo
spool off 
disconnect
