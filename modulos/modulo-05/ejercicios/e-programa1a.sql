--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

whenever sqlerror exit rollback
Prompt Conectando como c##user05 para  crear tabla con datos.
connect c##user05/user05
set serveroutput on

--Programa 1

--#TODO
  
--#TODO

   prompt Creara la tabla numeros

     create table numeros(
      id number constraint numeros_pk primary key,
      numero_aleatorio number
    );

    prompt Insertará 10000 registros

--#TODO

/
--#TODO

 Prompt registros en tabla numeros
--#TODO
 
--#TODO

