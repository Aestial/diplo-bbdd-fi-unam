--@Autor:    Jaime Hernandez Vazquez
--@Fecha creación:  14/12/2024
--@Descripción: 

Prompt Explorando segmentos
connect jorge05/jorge

--#TODO
begin 
execute immediate 'drop table x##user05.empleado';
exception
  when others then
    null;
end;
--#TODO
/

Prompt creando una tabla para explorar sus segmentos 
create table empleado(
  id number(10,0) constraint empleado_pk primary key,
  nombre_completo varchar2(100) not null,
  num_cuenta varchar2(20) not null,
  expediente clob not null,
  constraint empleado_num_cuenta_uk unique(num_cuenta)
) segment creation immediate;

Prompt creando un índice explícito
--#TODO
create index empleado_email_ix on empleado(email);
--#TODO


Prompt Mostrar los segmentos generados
Prompt mostrando los segmentos asociados con esta tabla.
set linesize window
--#TODO
col table_name format a30
col column_name format a30
col segment_name format a30
col index_name format a30
select segment_name,segment_type,
  tablespace_name,bytes/1024 segment_size_kb,blocks,extents
from user_segments
where segment_name like '%EMPLEADO%';
--#TODO

Prompt mostrar los segmentos LOB
Prompt mostrando datos de user_lobs
--#TODO
col index_name format a30
col column_name format a30
select table_name,column_name,segment_name,tablespace_name,index_name 
from  user_lobs 
where table_name ='EMPLEADO';
--#TODO

Prompt Mostrar todo en una sola consulta.

select s.segment_name,s.segment_type,s.tablespace_name,
  s.bytes/1024 segment_size_kb,s.blocks,s.extents
from user_segments s
left join user_lobs b
on s.segment_name = b.segment_name
or s.segment_name = b.index_name
where (s.segment_name like '%EMPLEADO%' 
  or b.table_name ='EMPLEADO'
);

Prompt limpieza
drop table empleado;