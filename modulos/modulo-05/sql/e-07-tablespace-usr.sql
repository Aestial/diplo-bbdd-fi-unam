
Prompt connect sys/system2 as sysdba

set linesize window
col property_name format a30
col property_value format a30
col tablespace_name format a30
col username  format a30

Prompt mostrando datos de los tablespaces empleando database_properties
select property_name 
from database_properties
where property_name 
like '%TABLESPACE%';

Prompt mostrando datos de los tablespaces a través de user_users (jorge05)
connect jorge05/jorge
select default_tablespace,temporary_tablespace,local_temp_tablespace
from user_users;

Prompt mostrando tablespace undo empleado por todos los usuarios.
connect sys/system2 as sysdba
show parameter undo_tablespace

Prompt mostrando quotas de almacenamiento para los usuarios
select tablespace_name,username, bytes/1024/1024 quota_mb,blocks,max_blocks
from dba_ts_quotas;

Prompt Mostrar los datos del ts temporal
select tablespace_name, tablespace_size/1024/1024 ts_size_mb, 
  allocated_space/1024/1024 allocated_space_mb,
  free_space/1024/1024 free_space_mb
from dba_temp_free_space;

--Instrucción para cambiar el ts temporal:
--alter database default temporary tablespace <tablespace_name>;

exit