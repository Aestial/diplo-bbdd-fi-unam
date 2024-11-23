--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

prompt Autenticando como sysdba en CDB
connect sys/system2 as sysdba

prompt Creando al common user c##user01
--#TODO
drop user if exists c##user01 cascade;
create user c##user01 identified by user01 quota unlimited on users;
grant create session, create table to c##user01;
--#TODO
