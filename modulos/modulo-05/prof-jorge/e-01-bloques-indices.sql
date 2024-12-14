--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: Script empleado para generar un índice B* tree a partir
--              De una tabla con gran cantidad de registros.

whenever sqlerror exit rollback;

Prompt Módulo 05  - Ejercicio 1

Prompt creando usuario  jorge05 en caso de no existir

connect sys/system2 as sysdba

declare
  v_count number;
begin
  select count(*) into v_count 
  from all_users
  where username='JORGE05';
  if v_count > 0 then
    execute immediate 'drop user jorge05 cascade';
  end if;
end;
/

Prompt creando usuario jorge05
create  user jorge05 identified by jorge quota unlimited on users;
grant create session, create table to jorge05;

Prompt conectando como usuario jorge05
connect jorge05/jorge

Prompt creando tabla t01_id
create table t01_id (
  id number(10,0) constraint t01_id_pk primary key
);

insert into t01_id values(1);

Prompt mostrando datos del índice
--checar index_stats
--comando para generar estadísticas
-- analyze index t01_id_pk validate structure offline;

set linesize window
col index_type format a20
col table_name format a20
select index_type,table_name,uniqueness,
  tablespace_name, status, blevel, distinct_keys
from user_indexes where index_name='T01_ID_PK';

Prompt Observar que no se muestran datos antes de recolectar estadisticas.
Pause [Enter] para continuar

Prompt recolectando estadísticas
begin
  dbms_stats.gather_index_stats(
    ownname => 'JORGE05',
    indname => 'T01_ID_PK'
  );
end;
/

Prompt mostrando datos nuevamente
select index_type,table_name,uniqueness,
  tablespace_name, status, blevel, distinct_keys
from user_indexes where index_name='T01_ID_PK';

Pause Realizar carga de 1,000,000 de registros [Enter] para continuar

begin
  for v_index in 2..1000000 loop
    insert into t01_id values (v_index);
  end loop;
end;
/
commit;

Prompt calculando estadisticas nuevamente
begin
  dbms_stats.gather_index_stats(
    ownname => 'JORGE05',
    indname => 'T01_ID_PK'
  );
end;
/

Prompt mostrando datos nuevamente
select index_type,table_name,uniqueness,
  tablespace_name, status, blevel, distinct_keys
from user_indexes where index_name='T01_ID_PK';

Prompt listo
disconnect.
