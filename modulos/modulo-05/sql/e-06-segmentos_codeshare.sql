--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

Prompt Explorando segmentos
connect c##user05/user05

--#TODO
begin
  execute immediate 'drop table c##user05.empleado';
exception
  when others then
    null;
end;
--#TODO
/

create table empleado(
  empleado_id number(10,0) constraint empleado_pk primary key,
    curp  varchar2(18) constraint empleado_curp_uk unique,
    email varchar2(100),
    foto  blob,
    cv    clob,
    perfil  varchar2(4000)
) segment creation immediate;

Prompt creando un índice explícito
--#TODO
create index empleado_email_ix on empleado(email);
--#TODO

Prompt mostrando los segmentos asociados con esta tabla.
set linesize window
--#TODO
col segment_name format a30
select tablespace_name, segment_name, segment_type, blocks, extents
from user_segments
where segment_name like '%EMPLEADO%';
--#TODO

Prompt mostrando datos de user_lobs
--#TODO
col index_name format a30
col column_name format a30
select tablespace_name, segment_name, index_name, column_name
from user_lobs
where table_name ='EMPLEADO';
--#TODO

Prompt mostrando datos de user_lobs separados
col index_name format a30
col column_name format a30
--#TODO PERO POSTERIOR DE PRIMER EJECUCIÓN
select tablespace_name, segment_name, column_name
from user_lobs
where table_name ='EMPLEADO'
union
select tablespace_name, index_name, column_name
from user_lobs
where table_name ='EMPLEADO';
--#TODO