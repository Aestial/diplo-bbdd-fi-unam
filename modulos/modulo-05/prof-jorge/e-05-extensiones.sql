--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción:

connect sys/system2 as sysdba

Prompt creando tabla de ejemplo
create table jorge05.t04_ejemplo_extensiones(
  str char(1024)
);

Prompt consultando los datos de las extensiones (se espera 0 registros)
set linesize window 
select segment_type,tablespace_name,file_id,extent_id,
  block_id, bytes/1023 extent_size_kb, blocks
from dba_extents
where segment_name='T04_EJEMPLO_EXTENSIONES';

Prompt crear una nueva extensión de forma manual
alter table jorge05.t04_ejemplo_extensiones allocate extent;

Prompt cargando 100 registros
begin
  for v_index in 1..100 loop
    insert into jorge05.t04_ejemplo_extensiones values('A');
  end loop;
end;
/
commit;

Prompt ejecutando procedimiento
set serveroutput on 
declare
  v_unformatted_blocks number;
  v_unformatted_bytes  number;
  v_fs1_blocks         number;
  v_fs1_bytes          number;
  v_fs2_blocks         number;
  v_fs2_bytes          number;
  v_fs3_blocks         number;
  v_fs3_bytes          number;
  v_fs4_blocks         number;
  v_fs4_bytes          number;
  v_full_blocks        number;
  v_full_bytes         number;
begin
  dbms_space.space_usage(
    segment_owner          => 'JORGE05',
    segment_name           => 'T04_EJEMPLO_EXTENSIONES',
    segment_type           => 'TABLE',
    unformatted_blocks     => v_unformatted_blocks,
    unformatted_bytes      => v_unformatted_bytes ,
    fs1_blocks             => v_fs1_blocks        ,
    fs1_bytes              => v_fs1_bytes         ,
    fs2_blocks             => v_fs2_blocks        ,
    fs2_bytes              => v_fs2_bytes         ,
    fs3_blocks             => v_fs3_blocks        ,
    fs3_bytes              => v_fs3_bytes         ,
    fs4_blocks             => v_fs4_blocks        ,
    fs4_bytes              => v_fs4_bytes         ,
    full_blocks            => v_full_blocks       ,
    full_bytes             => v_full_bytes                 
  );

  dbms_output.put_line('v_unformatted_blocks '||v_unformatted_blocks);
  dbms_output.put_line('v_unformatted_bytes  '||v_unformatted_bytes );
  dbms_output.put_line('v_fs1_blocks         '||v_fs1_blocks        );
  dbms_output.put_line('v_fs1_bytes          '||v_fs1_bytes         );
  dbms_output.put_line('v_fs2_blocks         '||v_fs2_blocks        );
  dbms_output.put_line('v_fs2_bytes          '||v_fs2_bytes         );
  dbms_output.put_line('v_fs3_blocks         '||v_fs3_blocks        );
  dbms_output.put_line('v_fs3_bytes          '||v_fs3_bytes         );
  dbms_output.put_line('v_fs4_blocks         '||v_fs4_blocks        );
  dbms_output.put_line('v_fs4_bytes          '||v_fs4_bytes         );
  dbms_output.put_line('v_full_blocks        '||v_full_blocks       );
  dbms_output.put_line('v_full_bytes         '||v_full_bytes        );

end;
/

Prompt limpieza
drop table jorge05.t04_ejemplo_extensiones;