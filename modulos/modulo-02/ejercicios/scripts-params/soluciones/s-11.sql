--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: Administración de parámetros

Prompt actualizando parámetros

prompt conectando como sysdba
connect sys/system2 as sysdba

Prompt Realizando consulta inicial de parámetros
col name format a28
col value format a40
set linesize window
select name,value,isses_modifiable,issys_modifiable,ispdb_modifiable,con_id
from v$system_parameter
where name in ('nls_date_format','db_domain','deferred_segment_creation');

/**
NAME                         VALUE                                    ISSES ISSYS_MOD ISPDB     CON_ID
---------------------------- ---------------------------------------- ----- --------- ----- ----------
nls_date_format                                                       TRUE  FALSE     TRUE           0
db_domain                    fi.unam                                  FALSE FALSE     TRUE           0
deferred_segment_creation    TRUE                                     TRUE  IMMEDIATE TRUE           0

*/


Prompt realizando un respaldo
create pfile from spfile;

prompt modificando el valor de nls_date_format
Prompt Nivel sesión ?  OK
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
pause [Enter] para continuar

Prompt nivel Instancia ? Se espera error
alter system set nls_date_format='dd/mm/yyyy' scope=memory;
pause [Enter] para continuar

Prompt nivel Instancia y spfile ? Se espera error
alter system set nls_date_format='dd/mm/yyyy' scope=both;
pause [Enter] para continuar

Prompt nivel spfile ? OK
alter system set nls_date_format='dd/mm/yyyy' scope=spfile;
pause [Enter] para continuar

Prompt nivel PBD ? OK
alter session set container=jrcdiplo_s2;
alter system set nls_date_format='yyyy/mm/dd' container=current  scope=spfile;
alter session set container=cdb$root;
pause [Enter] para continuar


Prompt modificando el valor para db_domain
Prompt Nivel sesión ?  Se espera error.
alter session set db_domain='fi.unam.mx';
pause [Enter] para continuar

Prompt Nivel instancia ?  Se espera error.
alter system set db_domain='fi.unam.mx' scope=memory;
pause [Enter] para continuar

Prompt Nivel instancia y spfile  ?  Se espera error.
alter system set db_domain='fi.unam.mx' scope=both;
pause [Enter] para continuar

Prompt Nivel spfile  ?  OK
alter system set db_domain='fi.unam.mx' scope=spfile;
pause [Enter] para continuar

Prompt Nivel PDB  ?  OK
alter session set container=jrcdiplo_s2;
alter system set db_domain='fi.unam.pdb' container=current scope=spfile;
alter session set container=cdb$root;
pause [Enter] para continuar


Prompt modificando el valor para  deferred_segment_creation
Prompt Nivel sesion ? OK
alter session set deferred_segment_creation=true;
pause [Enter] para continuar

Prompt Nivel Instancia ? OK
 alter system set deferred_segment_creation=false scope=memory;
 pause [Enter] para continuar

Prompt Nivel Instancia y SFILE ? OK
 alter system set deferred_segment_creation=true scope=both;
 pause [Enter] para continuar

Prompt Nivel SFILE ? OK
 alter system set deferred_segment_creation=false scope=spfile;
 pause [Enter] para continuar

Prompt Nivel PDB ? OK
alter session set container=jrcdiplo_s2;
alter system set deferred_segment_creation=false container=current scope=spfile;
alter session set container=cdb$root;
pause [Enter] para continuar


Prompt limpieza:

Prompt para el parametro nls_date_format
alter system reset nls_date_format scope=spfile;
--reset en pdb
alter session set container=jrcdiplo_s2;
alter system reset nls_date_format scope=spfile;
alter session set container=cdb$root;

prompt para db_domain
alter system reset db_domain scope=spfile;
--reset en pdb
alter session set container=jrcdiplo_s2;
alter system reset db_domain scope=spfile;
alter session set container=cdb$root;


Prompt para deferred_segment_creation
alter system reset deferred_segment_creation scope=memory;
alter system reset deferred_segment_creation scope=spfile;
--reset en pdb
alter session set container=jrcdiplo_s2;
alter system reset deferred_segment_creation scope=spfile;
alter session set container=cdb$root;

--- actualizar db_domain
alter system set db_domain='fi.unam' container=all scope=spfile;



Prompt Reiniciar para comprobar estado original de los parámetro
shutdown immediate
startup

Prompt mostrando nuevamente los valores en session/memoria (v$parameter)
col name format a28
col value format a40
set linesize window
select name,value,isses_modifiable,issys_modifiable,ispdb_modifiable,con_id
from v$system_parameter
where name in ('nls_date_format','db_domain','deferred_segment_creation');


Prompt mostrando nuevamente los valores en spfile (v$spparameter)
select name,value,con_id
from v$spparameter
where name in ('nls_date_format','db_domain','deferred_segment_creation');

Prompt nivel PDB
alter session set container=jrcdiplo_s2;
select name,value,con_id
from v$spparameter
where name in ('nls_date_format','db_domain','deferred_segment_creation');
alter session set container=cdb$root;

Prompt Listo!