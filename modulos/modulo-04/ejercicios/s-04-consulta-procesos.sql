--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

Prompt conectando como sysdba en cdb$root
connect sys/system2 as sysdba
set linesize window

Prompt Consulta 1
/* Generar una consulta que muestre el total de procesos de background, llamados
   también procesos del sistema, así como el total de los procesos empleados para
   atender o procesar peticiones de un user process, llamados también foreground
   processes.
*/
--#TODO
select 
  (select count(*) from v$process where background=1) as total_background,
  (select count(*) from v$process where background is null) as total_foreground
from dual;
--TODO#

Prompt Consulta 2
/*
 Generar una consulta que muestre los siguientes datos respecto a procesos que
 no son de sistema (foreground processes)
   * Total de memoria PGA en uso  (MB)
   * Total de memoria PGA que puede ser liberada (MB)
   * Total de memoria PGA que se ha reservado (MB)
   * La mayor cantidad que memoria PGA que se ha empleado desde el inicio de la instancia (MB).
*/
--#TODO
select 
  round(sum(pga_used_mem)/1024/1024,2) pga_en_uso,
  round(sum(pga_freeable_men)/1024/1024,2) pga_libre,
  round(sum(pga_alloc_mem)/1024/1024,2) pga_reservada,
  round(sum(pga_max_mem)/1024/1024,2) max_pga_reservada
from v$Process
where background is null;
--TODO#

Prompt Consulta 3.
/*
 Repetir la consulta anterior pero ahora para procesos de background.
*/
--#TODO
select 
  round(sum(pga_used_mem)/1024/1024,2) pga_en_uso,
  round(sum(pga_freeable_men)/1024/1024,2) pga_libre,
  round(sum(pga_alloc_mem)/1024/1024,2) pga_reservada,
  round(sum(pga_max_mem)/1024/1024,2) max_pga_reservada
from v$process
where background =1;
--TODO#

Prompt Consulta 4.
/*
Mostrar el nombre del proceso de background que tiene el mayor uso de memoria
*/
--#TODO
select pname, 
  round(pga_max_mem)/1024/1024,2) max_pga_empleada,
  round(pga_alloc_mem/1024/1024,2) pga_reservada
from v$process
where pga_alloc_mem = (
  -- Se necesita una sub consulta para ejecutar groupby->max
  select max(pga_alloc_mem)
  from v$process
  where background =1
) and background =1;
--TODO#


Prompt Consulta 5.
/*
Mostrar el identificador, usuario, número de serial y cantidad de memoria  PGA reservada
a su correspondiente server process.
*/

col username format a40
--#TODO
select s.sid,s.serial#,s.username, round(p.pga_alloc_mem/1024/1024,2) pga_reservada
from v$session s, v$process p
where hextoraw(s.paddr)=p.addr
and s.username is not null;
--TODO#

Prompt 6. 
/*
6. Considerar la siguiente lista de procesos de background: 
    * DB Writer
    * Log writer
    * System Monitor
    * Process Monitor
    * Los 2 primeros shared server processes
    * Los 2 primeros procesos contenidos en el DRCP
  Determinar los siguientes datos:
    * Identificador del proceso a nivel instancia
    * Identificador del proceso a nivel sistema operativo
    * Ruta absoluta donde se encuentra su bitácora
    * Documento JSON que muestra sus principales características
    * Cantidad de PGA asignada en MB.
*/
col tracefile format a60
col attributes format a80
--#TODO
select pid,sosid,pname,tracefile,attributes, round(p.pga_alloc_mem/1024/1024,2) pga_reservada
from v$process p
where pname in ('DBW0','LGWR','SMON','PMON','MMON','S000','S001','L001','L002');
-- L001 Pool server
--TODO#

