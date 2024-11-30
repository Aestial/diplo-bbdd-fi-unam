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
  fecha,total_sga_1,total_sga_2,total_sga_3,sga_free,
  pga_param,pga_total_2,pga_reservada,pga_reservada_max,pga_en_uso,pga_libre,pga_auto_w_areas,pga_manual_w_areas,
  log_buffer,db_buffer_cache,shared_pool,large_pool,java_pool,stream_pool,
  inmemory
) values (
  trunc(sysdate),
  
)
--TODO#

commit;

alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
select * from user04monitor.memory_areas order by id;

prompt listo!