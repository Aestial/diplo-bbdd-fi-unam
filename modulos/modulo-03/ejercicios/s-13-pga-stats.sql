--@Autor: Hernandez Vazquez Jaime
--@Fecha creación: 29/11/2024
--@Descripción: Estadísticas que describen las PGA antes y después de una carga
prompt 1. Conectando como sys
connect sys/system2 as sysdba

prompt 2. Consultando estadísticas - PGA
set linesize window
--#TODO
select name, 'MB' unit, value/1024/1024 value
from v$pgastat
where unit = 'bytes'
union all
select name, unit, value
from v$pgastat
where unit <> 'bytes'
order by value desc;
--TODO#

pause Analizar resultados, [Enter]  para continuar

prompt 3. Creando usuario user03pga en jhvdiplo_s2
alter session set container=jhvdiplo_s2;

drop user if exists user03pga;
create user user03pga identified by user03pga quota unlimited on users;
grant create session, create table to user03pga;

prompt 4. Mostrando uso de la PGA para el server process   

col program format a40
col sosid format a15

--#TODO
select sosid, username, program, 
  pga_used_mem/1024/1024 pga_used_mem_mb, 
  pga_alloc_mem/1024/1024 pga_alloc_mem_mb,
  pga_freeable_mem/1024/1024 pga_freeable_mem_mb,
  pga_max_mem/1024/1024 pga_max_mem_mb
from v$process p
where background is null
and username <> 'oracle';
--TODO#

Pause  ¿Cuánta memoria PGA se está empleando para este registro ? [Enter] continuar

prompt 5. Creando clon de all_objects ordenado
create table user03pga.all_objects_copy as
  select * from all_objects order by object_name;
 
Prompt 6. Ejecutar nuevamente consulta que muestra datos del server process
--#TODO
select sosid, username, program, 
  pga_used_mem/1024/1024 pga_used_mem_mb, 
  pga_alloc_mem/1024/1024 pga_alloc_mem_mb,
  pga_freeable_mem/1024/1024 pga_freeable_mem_mb,
  pga_max_mem/1024/1024 pga_max_mem_mb
from v$process p
where background is null
and username <> 'oracle';
--TODO#

--La operación order by requiere de cierta cantidad de RAM en la PGA para
--poder realizar el ordenamiento
Pause Comparar valores de uso de la PGA, ¿qué sucedió ? [Enter] continuar 

Prompt 7. Ejecutar nuevamente estadísticas de la PGA
--#TODO
select name, 'MB' unit, value/1024/1024 value
from v$pgastat
where unit = 'bytes'
union all
select name, unit, value
from v$pgastat
where unit <> 'bytes'
order by value desc;
--TODO#

--Las Work SQL areas incrementaron su valor entre otras cosas por el order by
Pause  ¿Qué componente se modificaron respeto a la primera consulta ? [Enter] continuar 




