--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>
Prompt Conectando como c##user01
connect c##user01/user01

Prompt Crear tabla de prueba y crear un registro
drop table if exists t_b_prueba;
--#TODO
create table t_b_prueba (id number);
insert into t_b_prueba values (trunc(dbms_random.value(1,100)));
--TODO#

Prompt La tabla 't_b_prueba' contiene:
select * from t_b_prueba;
Prompt registro creado, SIN commit