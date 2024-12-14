--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

whenever sqlerror exit rollback
Prompt Conectando como c##user05 para  crear tabla con datos.
connect c##user05/user05
set serveroutput on

--Programa 1

--#TODO
  drop table if exists c##user05.numeros;
--#TODO

   prompt Creara la tabla numeros

     create table numeros(
      id number constraint numeros_pk primary key,
      numero_aleatorio number
    );

    prompt Insertará 10000 registros

--#TODO
declare
  v_query varchar2(1000);
  v_index number;
  num_id number;
begin  
  --inserta 10,000 registros
  for v_index in 1..10000 loop
    execute immediate 'insert into numeros values(:id,:num_aleatorio)' using v_index, dbms_random.random;
  end loop;

  commit;
end;
/
--#TODO

 Prompt registros en tabla numeros
--#TODO
   select count(id)
   from numeros;
--#TODO

