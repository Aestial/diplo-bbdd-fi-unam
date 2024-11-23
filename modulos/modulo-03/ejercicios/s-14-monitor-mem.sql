--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

prompt conectando como sysdba 

connect sys/system2@jrcdiplo_s2 as sysdba

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

--TODO#

commit;

alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
select * from user04monitor.memory_areas order by id;

prompt listo!