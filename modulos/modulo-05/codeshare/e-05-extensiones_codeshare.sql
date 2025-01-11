--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

Prompt consultando extensiones, conectando como sys
connect sys/system2 as sysdba

begin
  execute immediate 'drop table c##user05.t04_ejemplo_extensiones';
exception
  when others then
    null;
end;
/

Prompt creando tabla de prueba
create table c##user05.t04_ejemplo_extensiones(
  str char(1024)
);

Prompt consultando datos de las extensiones
set linesize window
--#TODO
select segment_type, tablespace_name, file_id, extent_id, 
   block_id, bytes/1024 extent_size_kb, blocks
from dba_extents
where segment_name = 'T04_EJEMPLO_EXTENSIONES'
and   owner = 'C##USER05';
--#TODO

Prompt reservando una nueva extension
--#TODO
alter table c##user05.t04_ejemplo_extensiones allocate extent;
--#TODO

Prompt mostrando nuevamente los datos de las extensiones
select segment_type, tablespace_name,file_id,extent_id,block_id, 
  bytes/1024 extent_size_kb, blocks
from dba_extents
where segment_name ='T04_EJEMPLO_EXTENSIONES'
and owner = 'C##USER05';

Prompt insertando 100 registros
--#TODO
begin
  for v_index in 1..100 loop
    insert into c##user05.t04_ejemplo_extensiones values('A');
  end loop;
end;
/
commit;
--#TODO

Prompt mostrando datos de las extensiones despues de la inserción

select segment_type, tablespace_name,file_id,extent_id,block_id, 
  bytes/1024 extent_size_kb, blocks
from dba_extents
where segment_name ='T04_EJEMPLO_EXTENSIONES'
and owner = 'C##USER05';

Prompt mostrando estado de los bloques
set serveroutput on
declare
  v_unformatted_blocks number;
  v_unformatted_bytes number;
  v_fs1_blocks   number;
  v_fs1_bytes    number;
  v_fs2_blocks   number;
  v_fs2_bytes    number;
  v_fs3_blocks   number;
  v_fs3_bytes    number;
  v_fs4_blocks   number;
  v_fs4_bytes    number;
  v_full_blocks  number;
  v_full_bytes   number;
begin
  dbms_space.space_usage(
    'C##USER05'           ,
    'T04_EJEMPLO_EXTENSIONES'            ,
    'TABLE'            ,
    v_unformatted_blocks      ,
    v_unformatted_bytes       ,
    v_fs1_blocks              ,
    v_fs1_bytes               ,
    v_fs2_blocks              ,
    v_fs2_bytes               ,
    v_fs3_blocks              ,
    v_fs3_bytes               ,
    v_fs4_blocks              ,
    v_fs4_bytes               ,
    v_full_blocks             ,
    v_full_bytes              
  );

--#TODO
  dbms_output.put_line('Mostrando valores de los bloque despues de la inserción de 100 registros');
  dbms_output.put_line('v_unformatted_blocks = '||v_unformatted_blocks);
  dbms_output.put_line('v_unformatted_bytes = '||v_unformatted_bytes);
  dbms_output.put_line('v_fs1_blocks = '||v_fs1_blocks);
  dbms_output.put_line('v_fs1_bytes = '||v_fs1_bytes);
  dbms_output.put_line('v_fs2_blocks = '||v_fs2_blocks);
  dbms_output.put_line('v_fs2_bytes = '||v_fs2_bytes);
  dbms_output.put_line('v_fs3_blocks = '||v_fs3_blocks);
  dbms_output.put_line('v_fs3_bytes = '||v_fs3_bytes);
  dbms_output.put_line('v_fs4_blocks = '||v_fs4_blocks);
  dbms_output.put_line('v_fs4_bytes = '||v_fs4_bytes);
  dbms_output.put_line('v_full_blocks = '||v_full_blocks);
  dbms_output.put_line('v_full_bytes = '||v_full_bytes);
  --#TODO

end;
/

Prompt Eliminando 100 registros

begin
  execute immediate 'truncate table c##user05.t04_ejemplo_extensiones';
exception
  when others then
    null;
end;
/

Prompt mostrando datos de las extensiones despues de truncate

select segment_type, tablespace_name,file_id,extent_id,block_id, 
  bytes/1024 extent_size_kb, blocks
from dba_extents
where segment_name ='T04_EJEMPLO_EXTENSIONES'
and owner = 'C##USER05';

Prompt mostrando estado de los bloques después del truncate
set serveroutput on
declare
  v_unformatted_blocks number;
  v_unformatted_bytes number;
  v_fs1_blocks   number;
  v_fs1_bytes    number;
  v_fs2_blocks   number;
  v_fs2_bytes    number;
  v_fs3_blocks   number;
  v_fs3_bytes    number;
  v_fs4_blocks   number;
  v_fs4_bytes    number;
  v_full_blocks  number;
  v_full_bytes   number;
begin
--#TODO
  dbms_space.space_usage(
    'C##USER05'           ,
    'T04_EJEMPLO_EXTENSIONES'            ,
    'TABLE'            ,
    v_unformatted_blocks      ,
    v_unformatted_bytes       ,
    v_fs1_blocks              ,
    v_fs1_bytes               ,
    v_fs2_blocks              ,
    v_fs2_bytes               ,
    v_fs3_blocks              ,
    v_fs3_bytes               ,
    v_fs4_blocks              ,
    v_fs4_bytes               ,
    v_full_blocks             ,
    v_full_bytes              
  );
  --#TODO

  dbms_output.put_line('Mostrando valores de los bloques despues de truncate');
  dbms_output.put_line('v_unformatted_blocks =  '||v_unformatted_blocks);
  dbms_output.put_line('v_unformatted_bytes  = '||v_unformatted_bytes);
  dbms_output.put_line('v_fs1_blocks = '||v_fs1_blocks );
  dbms_output.put_line('v_fs1_bytes  = '||v_fs1_bytes  );
  dbms_output.put_line('v_fs2_blocks = '||v_fs2_blocks );
  dbms_output.put_line('v_fs2_bytes  = '||v_fs2_bytes  );
  dbms_output.put_line('v_fs3_blocks = '||v_fs3_blocks );
  dbms_output.put_line('v_fs3_bytes  = '||v_fs3_bytes  );
  dbms_output.put_line('v_fs4_blocks = '||v_fs4_blocks );
  dbms_output.put_line('v_fs4_bytes  = '||v_fs4_bytes  );
  dbms_output.put_line('v_full_blocks= '||v_full_blocks);
  dbms_output.put_line('v_full_bytes = '||v_full_bytes );

end;
/