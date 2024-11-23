--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>
prompt 1. Conectando como sys
connect sys/system2 as sysdba

prompt 2. Consultando estadísticas - PGA
set linesize window
--#TODO

--TODO#

pause Analizar resultados, [Enter]  para continuar

prompt 3. Creando usuario user03pga en jrcdiplo_s2
alter session set container=jrcdiplo_s2;

drop user if exists user03pga;
create user user03pga identified by user03pga quota unlimited on users;
grant create session, create table to user03pga;

prompt 4. Mostrando uso de la PGA para el server process   

col program format a40
col sosid format a15

--#TODO

--TODO#

Pause  ¿Cuánta memoria PGA se está empleando para este registro ? [Enter] continuar

prompt 5. Creando clon de all_objects ordenado
create table user03pga.all_objects_copy as
  select * from all_objects order by object_name;
 
Prompt 6. Ejecutar nuevamente consulta que muestra datos del server process
--#TODO

--TODO#

--La operación order by requiere de cierta cantidad de RAM en la PGA para
--poder realizar el ordenamiento
Pause Comparar valores de uso de la PGA, ¿qué sucedió ? [Enter] continuar 

Prompt 7. Ejecutar nuevamente estadísticas de la PGA
--#TODO

--TODO#

--Las Work SQL areas incrementaron su valor entre otras cosas por el order by
Pause  ¿Qué componente se modificaron respeto a la primera consulta ? [Enter] continuar 




