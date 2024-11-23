--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

Prompt 1. Autenticando como sys
connect sys/system2@jrcdiplo_s2 as sysdba

whenever sqlerror exit rollback

Prompt 2. Consulta 01
set pagesize 100
set linesize window
col title format a50

--#TODO

--TODO#

Prompt 3. Visualizando el plan de ejecución sin IM Column store.
--#TODO

--TODO#

Prompt 4. Habilitando In Memory column store
alter table user03imc.movie inmemory;

Prompt 5. Mostrando configuraciones asociadas con IM column store 
col table_name format a20 
--#TODO

--TODO#
pause Analizar resultados [Enter] para continuar

Prompt 6. Realizando consulta en v$im_segments previa al acceso
col segment_name format a20 
--#TODO

--TODO#
pause Analizar resultados [Enter] para continuar

Prompt 7. Realizando una consulta para provocar el poblado de la IM Column store
--#TODO

--TODO#
pause ¿Cuántos registros se obtuvieron? [Enter] para continuar

Prompt 8. consultando nuevamente en v$im_segments
--#TODO

--TODO#
pause Analizar resultados [Enter] para continuar

Prompt 9. Mostrando información de los IMCUs
set pagesize 30
col column_name format a20
col minimum_value format a20
col maximum_value format a50
--#TODO

--TODO#
pause Analizar resultados [Enter] para continuar

Prompt 10. Deshabilitando el uso de la IM C Store para mostrar estadísticas
--#TODO

--TODO#

Prompt 11. Mostrando estadísticas  del uso de la IM C Store  y sus IMCUs.
col display_name format a30
--#TODO

--TODO#

pause Analizar resultados [Enter] para continuar

Prompt 12. Habilitar nuevamente el uso de la IM C Store para mostrar estadísticas
--#TODO

--TODO#


Prompt 13. Mostrando estadísticas  del uso de la IM C Store  y sus IMCUs.
--#TODO

--TODO#
Pause Analizar resultados, [Enter] para continuar

Prompt 14. Mostrando nuevamente plan de ejecución con IM COlumn habilitada
--#TODO

--TODO#

pause Analizar resultados [Enter] para continuar

Prompt 15. Deshabilitando el uso de la IM column para que este script sea idempotente
--#TODO

--TODO#

--la limpieza del usuario se realiza en el script s-10-column-store.sql
prompt listo!
exit

