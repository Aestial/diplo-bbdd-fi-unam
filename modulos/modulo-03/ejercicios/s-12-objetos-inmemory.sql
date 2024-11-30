--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

Prompt 1. Autenticando como sys
connect sys/system2@jrcdiplo_s2 as sysdba

whenever sqlerror exit rollback

Prompt 2. Consulta 01
set pagesize 100
set linesize window
col title format a50

--#TODO
explain plan 
set statement_id = 'q1' for
select /*+ gather_plan_statistics */ title, trunc(duration/60, 1) duration_hrs
from user03imc.movie where upper(title) like '%WAR%';
--TODO#

Prompt 3. Visualizando el plan de ejecución sin IM Column store.
--#TODO
select * from table(dbms_xplan.display(statement_id=> 'q1'));
pause Analizar plan de ejecución [Enter] para continuar.

--TODO#

Prompt 4. Habilitando In Memory column store
alter table user03imc.movie inmemory;

Prompt 5. Mostrando configuraciones asociadas con IM column store 
col table_name format a20 
--#TODO
select table_name, inmemory, inmemory_compression, inmemory_priority,
inmemory_distribute
from dba_tables where table_name = 'MOVIE'
and owner = 'USER03IMC';
--TODO#
pause Analizar resultados [Enter] para continuar

Prompt 6. Realizando consulta en v$im_segments previa al acceso
col segment_name format a20 
--#TODO
select segment_name, bytes/1024/1024 MBs, inmemory_size/1024/1024 inmemory_size_mb,
  populate_status, inmemory_priority
from v$im_segments;
where segment_name = 'MOVIE'
and owner = 'USER03IMC';
--TODO#
pause Analizar resultados [Enter] para continuar

Prompt 7. Realizando una consulta para provocar el poblado de la IM Column store
--#TODO
select title, trunc(duration/60,1) duration_hrs
from user03imc.movie where upper(title) like '%WAR%';
--TODO#
pause ¿Cuántos registros se obtuvieron? [Enter] para continuar

Prompt 8. consultando nuevamente en v$im_segments
--#TODO
select segment_name, bytes/1024/1024 MBs, inmemory_size/1024/1024 inmemory_size_mb,
  populate_status, inmemory_priority
from v$im_segments;
where segment_name = 'MOVIE'
and owner = 'USER03IMC';
--TODO#
pause Analizar resultados [Enter] para continuar

Prompt 9. Mostrando información de los IMCUs
set pagesize 30
col column_name format a20
col minimum_value format a20
col maximum_value format a50
--#TODO
select column_number, column_name, minimum_value, maximum_value
from v$im_col_cu cu, dba_objects o, dba_tab_cols c
where cu.objd = o.data_object_id
and o.object_name = c.table_name
and cu.column_number = c.column_id
and o.owner = 'USER03IMC'
and o.object_name = 'MOVIE';
order by column_number, minimum_value;
--TODO#
pause Analizar resultados [Enter] para continuar

Prompt 10. Deshabilitando el uso de la IM C Store para mostrar estadísticas
--#TODO
alter session set  inmemory_query=disable;
select title, trunc(duration/60, 1) duration_hrs
from user03imc.movie where upper(title) like '%WAR%';
--TODO#

Prompt 11. Mostrando estadísticas  del uso de la IM C Store  y sus IMCUs.
col display_name format a30
--#TODO
select display_name,value
from v$mystat m, v$statname n
where m.statistic# = n.statistic#
and display_name in (
  'IM scan segments minmax eligible',
  'IM scan CUs delta pruned',
  'IM scan segments disk',
  'IM scan bytes in-memory',
  'IM scan bytes uncompressed',
  'IM scan rows',
  'IM scan blocks cache'
);
--TODO#

pause Analizar resultados [Enter] para continuar

Prompt 12. Habilitar nuevamente el uso de la IM C Store para mostrar estadísticas
--#TODO
alter session set  inmemory_query=enable;
select title, trunc(duration/60, 1) duration_hrs
from user03imc.movie where upper(title) like '%WAR%';
--TODO#

Prompt 13. Mostrando estadísticas  del uso de la IM C Store  y sus IMCUs.
--#TODO
select display_name,value
from v$mystat m, v$statname n
where m.statistic# = n.statistic#
and display_name in (
  'IM scan segments minmax eligible',
  'IM scan CUs delta pruned',
  'IM scan segments disk',
  'IM scan bytes in-memory',
  'IM scan bytes uncompressed',
  'IM scan rows',
  'IM scan blocks cache'
);
--TODO#
Pause Analizar resultados, [Enter] para continuar

Prompt 14. Mostrando nuevamente plan de ejecución con IM COlumn habilitada
--#TODO
explain plan 
set statement_id = 'q2' for
select /*+ gather_plan_statistics */ title, trunc(duration/60, 1) duration_hrs
from user03imc.movie where upper(title) like '%WAR%';

select * from table(dbms_xplan.display(statement_id=> 'q2'));

--TODO#

pause Analizar resultados [Enter] para continuar

Prompt 15. Deshabilitando el uso de la IM column para que este script sea idempotente
--#TODO
alter table user03imc.movie no inmemory;
--TODO#

--la limpieza del usuario se realiza en el script s-10-column-store.sql
prompt listo!
exit

