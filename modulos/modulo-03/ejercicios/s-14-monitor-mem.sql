--@Autor: Hernandez Vazquez Jaime
--@Fecha creación: 30/11/2024
--@Descripción: Estadísticas de memoria simulando una carga de trabajo

prompt conectando como sysdba 

connect sys/system2@jhvdiplo_s2 as sysdba

set linesize window
Prompt creando usuario user04monitor
drop user if exists user04monitor cascade;

create user user04monitor identified by user04monitor quota unlimited on users; 
grant create session, create table to user04monitor;

Prompt Creando la tabla MEMORY_AREAS
drop table if exists user04monitor.memory_areas;

create table user04monitor.memory_areas(
  id number generated always as identity,
  fecha date,
  total_sga_1 number,
  total_sga_2 number,
  total_sga_3 number,
  sga_free  number,
  --pga
  pga_param number,
  pga_total_2 number,
  pga_reservada number,
  pga_reservada_max number,
  pga_en_uso number,
  pga_libre number,
  pga_auto_w_areas number,
  pga_manual_w_areas number,
  --pools
  log_buffer number,
  db_buffer_cache number,
  shared_pool number,
  large_pool number,
  java_pool number,
  stream_pool number,
  inmemory number
);

prompt Agregando un nuevo registro en user04monitor.memory_areas 
--#TODO
insert into user04monitor.memory_areas(
  fecha,
  --sga
  total_sga_1,total_sga_2,total_sga_3, sga_free,
  --pga
  pga_param,pga_total_2,pga_reservada,pga_reservada_max,pga_en_uso,pga_libre,
  pga_auto_w_areas,pga_manual_w_areas,
  --pools
  log_buffer,db_buffer_cache,shared_pool,large_pool,java_pool,stream_pool,
  inmemory 
) values (
  sysdate,
  -- a partir de v$sga  
  trunc(
    (  
      (select sum(value) from v$sga)-
      (select current_size from v$sga_dynamic_free_memory)
    )/1024/1024,2
  )
  ,
  --a partir de v$sga_dynamic_components  
  trunc(
    (
      (select sum(current_size) from v$sga_dynamic_components) +
      (select value from v$sga where name ='Fixed Size') +
      (select value from v$sga where name ='Redo Buffers')
    ) /1024/1024,2  
  ),
  -- a partir de v$sgainfo  
  trunc(
    (
      select sum(bytes) from v$sgainfo where name not in (
      'Granule Size',
      'Maximum SGA Size',
      'Startup overhead in Shared Pool',
      'Free SGA Memory Available',
      'Shared IO Pool Size'
      )
    ) /1024/1024,2
  ),
  --Memoria libre
  trunc(
    (select current_size/1024/1024 from v$sga_dynamic_free_memory),2
  ),
  --total memoria PGA
  trunc(
    (select value/1024/1024 
      from v$pgastat where name ='aggregate PGA target parameter'
    ),2
  ),
  --total a partir de la RAM libre de la SGA
  trunc(
    (select current_size/1024/1024 from v$sga_dynamic_free_memory)  ,2
  ),
  --pga total reservada
  trunc(
    (select value/1024/1024 
      from v$pgastat where name ='total PGA allocated'
    ),2
  ),
  --pga total reservada máxima
  trunc(
    (select value/1024/1024 
      from v$pgastat where name ='maximum PGA allocated'
    ),2
  ),
  --pga en uso 
  trunc(
    (select value/1024/1024 
      from v$pgastat where name ='total PGA inuse'
    ),2
  ),
  --pga libre
  trunc(
    (select value/1024/1024 
      from v$pgastat where name ='total freeable PGA memory'
    ),2
  ),
  --pga work areas auto
  trunc(
    (select value/1024/1024 
      from v$pgastat where name ='total PGA used for auto workareas'
    ),2
  ),
  --pga work areas manual
  trunc(
    (select value/1024/1024 
      from v$pgastat where name ='total PGA used for manual workareas'
    ),2
  ),
  --log buffer
  (select trunc(bytes/1024/1024,2) from v$sgainfo where name='Redo Buffers'),
  --db buffeer cache
  (select trunc(bytes/1024/1024,2) from v$sgainfo where name='Buffer Cache Size'),
  --shared pool
  (select trunc(bytes/1024/1024,2) from v$sgainfo where name='Shared Pool Size'),
  --large pool
  (select trunc(bytes/1024/1024,2) from v$sgainfo where name='Large Pool Size'),  
  --Java pool size
  (select trunc(bytes/1024/1024,2) from v$sgainfo where name='Java Pool Size'),
  --stream pool size 
  (select trunc(bytes/1024/1024,2) from v$sgainfo where name='Streams Pool Size'),
  --IM size
  (select trunc(bytes/1024/1024,2) from v$sgainfo where name='In-Memory Area Size')
  
  
  
);
--TODO#

commit;

alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
select * from user04monitor.memory_areas order by id;

prompt listo!