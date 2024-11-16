--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: Administración de parámetros

Prompt actualizando parámetros

prompt conectando como sysdba
connect sys/system1 as sysdba

Prompt realizando un respaldo
create pfile from spfile;

prompt modificando el valor de nls_date_format
--#TODO

--TODO#

Prompt modificando el valor para db_domain
--#TODO

--TODO#

Prompt modificando el valor para  deferred_segment_creation

--#TODO

--TODO#

Prompt limpieza:

Prompt para el parametro nls_date_format
--#TODO

--TODO#

prompt para db_domain
--#TODO

--TODO#

Prompt para deferred_segment_creation
--#TODO

--TODO#

col name format a30
col value format a30
col default_value format a30

Prompt mostrando nuevamente los valores en session/memoria (v$parameter)
--#TODO

--TODO#

Prompt mostrando nuevamente los valores en spfile (v$spparameter)
--#TODO

--TODO#