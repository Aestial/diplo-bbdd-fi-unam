--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: pctfree ejemplos

whenever sqlerror exit rollback
connect jorge05/jorge

Prompt creando tabla con pctfree 0
create table t02_random_str_0(
  str char(18) 
) pctfree 0;

Prompt creando tabla con pctfree 50
create table t02_random_str_50(
  str char(18) 
) pctfree 50;

Pause Iniciando carga de 10,000 registros por tabla [Enter] para iniciar.
declare
  v_str char(18);
begin
  v_str := rpad('A',18,'X');
  for v_index in 1..10000 loop
    insert into t02_random_str_0 values(v_str);
    insert into t02_random_str_50 values(v_str);
  end loop;
end;
/
commit;
set pagesize 100
Prompt consultando total de bloques a través del rowid para pctfree 0
select dbms_rowid.rowid_relative_fno(rowid) as file_number,
  dbms_rowid.rowid_block_number(rowid) as block_number,
  count(*) blocks_in_file
from t02_random_str_0
group by dbms_rowid.rowid_relative_fno(rowid),
  dbms_rowid.rowid_block_number(rowid)
order by 1,2;

Prompt consultando total de bloques a través del rowid para pctfree 50
select dbms_rowid.rowid_relative_fno(rowid) as file_number,
  dbms_rowid.rowid_block_number(rowid) as block_number,
  count(*) blocks_in_file
from t02_random_str_50
group by dbms_rowid.rowid_relative_fno(rowid),
  dbms_rowid.rowid_block_number(rowid)
order by 1,2;


