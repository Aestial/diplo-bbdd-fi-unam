--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

Prompt 1. Conectando como usuario c##userJava 

connect c##userJava/userJava

Prompt 2. Creando procedimiento almacenado
--#TODO
create or replace procedure resizeImage(
  filePath varchar2, width number, height number) as language java
  name 'mx.edu.unam.fi.dipbd.ResizeImage.resizeImage(java.lang.String,int,int)';
/
show errors;
--TODO#

prompt 3. Copiando la imagen a /tmp
!cp paisaje.png /tmp 

prompt 4. Invocando el procedimiento  --# Num 3 en documento.md
--#TODO
exec resizeImage('/tmp/paisaje.png',734,283)
--TODO#

prompt 5. Mostrando el contenido de la carpeta /tmp --# Num 4 en documento.md
!ls -lh /tmp/paisaje.png
!ls -lh /tmp/output-paisaje.png

Prompt 6. Mostrando operaciones de ajuste de memoria para el java pool
--# Num 5 en documento.md
connect sys/system2 as sysdba 
col component format a15
col parameter format a15
set linesize window
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';

--#TODO Query
select component, oper_type, 
  trunc(initial_size/1024/1024) initial_size_mb,
  trunc(target_size/1024/1024) target_size_mb,
  trunc(final_size/1024/1024) final_size_mb,
  start_time, parameter
from v$sga_resize_ops
where component = 'java pool'
order by start_time;
--TODO#

pause [Enter] para continuar
