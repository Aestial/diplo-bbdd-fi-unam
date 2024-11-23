--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

Prompt 1. Conectando como usuario c##userJava 

connect c##userJava/userJava

Prompt 2. Creando procedimiento almacenado
--#TODO

--TODO#

prompt 3. Copiando la imagen a /tmp
!cp paisaje.png /tmp 

prompt 4. Invocando el procedimiento
--#TODO

--TODO#

prompt 5. Mostrando el contenido de la carpeta /tmp
!ls -lh /tmp/paisaje.png
!ls -lh /tmp/output-paisaje.png

Prompt 6. Mostrando operaciones de ajuste de memoria para el java pool

connect sys/system2 as sysdba 
col component format a15
col parameter format a15
set linesize window
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';

--#TODO

--TODO#
pause [Enter] para continuar
