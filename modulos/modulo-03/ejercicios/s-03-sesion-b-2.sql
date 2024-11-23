--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>
Prompt Conectando como c##user01 en cdb$root
connect c##user01/user01

Prompt Insertar otro registro en 't_b_prueba' y ejecutar *commit*
--#TODO
insert into t_b_prueba values (trunc(dbms_random.value(1,100)));
commit;
--TODO#

Prompt Mostrar los datos de la tabla 't_b_prueba':
select * from t_b_prueba;
