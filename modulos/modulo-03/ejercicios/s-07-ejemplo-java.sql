--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

prompt 1. Conectando como sys
connect sys/system2 as sysdba

prompt 2. Creando usuario c##userJava, otorgar privilegios
drop user if exists c##userJava cascade;
create user c##userJava identified by userJava quota unlimited on users;
grant create table, create session, create procedure to c##userJava;

Prompt 3. Otorgar permisos para cargar archivos asociados con los programas Java
--#TODO

--TODO#
prompt Listo!