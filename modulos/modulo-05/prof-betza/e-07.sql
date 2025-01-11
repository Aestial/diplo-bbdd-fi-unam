--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

Prompt conexion
connect sys/system2 as sysdba

set linesize window
col property_name format a30
col property_value format a30
col tablespace_name format a30
col username  format a30

Prompt mostrando datos de los tablespaces empleando database_properties
--#TODO
select property_name 
from database_properties
where property_name 
like '%TABLESPACE%';
--#TODO

Prompt mostrando datos de los tablespaces a través de user_users (c##user05)
--#TODO
connect c##user05/user05
select default_tablespace,temporary_tablespace,local_temp_tablespace
from user_users;
--#TODO

Prompt mostrando tablespace undo empleado por todos los usuarios.
--#TODO
connect sys/system2 as sysdba
show parameter undo_tablespace
--#TODO

Prompt mostrando quotas de almacenamiento para los usuarios
--#TODO
select tablespace_name,username, bytes/1024/1024 quota_mb,blocks,max_blocks
from dba_ts_quotas;
--#TODO

Prompt Mostrar los datos del ts temporal
--#TODO
select tablespace_name, tablespace_size/1024/1024 ts_size_mb, 
  allocated_space/1024/1024 allocated_space_mb,
  free_space/1024/1024 free_space_mb
from dba_temp_free_space;
--#TODO

--Instrucción para cambiar el ts temporal:
--alter database default temporary tablespace <tablespace_name>;

exit