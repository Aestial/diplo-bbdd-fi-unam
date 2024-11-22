--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

Prompt Conectando a PDB como SYS...
connect sys/system2@jrcdiplo_s2 as sysdba

prompt Creando usuario user01
--#TODO
drop user if exists user01 cascade;
create user user01 identified by user01 quota unlimited on users;
grant create session, create table to user01;
--TODO#

Prompt Creando tabla de prueba
--#TODO
drop table if exists user01.test;
create table user01.test(id number) segment creation immediate;
--TODO#

Prompt Limpiando el Shared Pool y el Library Chache
--#TODO

--TODO#

prompt 1. Sentencias SQL con bind variables
set timing on

--#TODO

--TODO#

prompt 2. Sentencias SQL sin bind variables

--#TODO

--TODO#

Prompt Mostrando datos de la sentencia SQL con bind variables
--#TODO

--TODO#

Prompt Mostrando datos de la sentencia SQL sin bind variables
--#TODO

--TODO#

set timing off

Prompt Limpieza...
--#TODO
connect sys/system2@jrcdiplo_s2 as sysdba
drop user user01 cascade;
--TODO#
