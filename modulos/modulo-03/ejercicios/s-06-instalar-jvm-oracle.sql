--@Autor: Hernandez Vazquez Jaime
--@Fecha creación: 23/11/2024
--@Descripción: Instalación de Java Virtual Machine para ejecutar scripts en Java 

prompt 1. conectando como sys en cdb$root
connect sys/system2 as sysdba
whenever sqlerror exit rollback;

prompt 2. Validando usuario del s.o.
--#TODO
declare 
  v_user varchar2(128);
begin
  v_user := sys_context('USERENV', 'OS_USER');
  if v_user != 'oracle' then
    raise_application_error(-20001, 
    'El script debe ser ejecutado por el usuario oracle del sistema operativo');
    end if;
end;
/
--TODO#

Prompt instalando Oracle JVM

Prompt 3. Modificando parámetro _system_trig_enabled
--#TODO
alter system set _system_trig_enabled=false scope=memory;
--TODO#

Prompt 4. Creando directorio para bitacoras
!mkdir -p /tmp/jvm

Prompt 5. Habilitando javavm
--#TODO
host ${ORACLE_HOME}/perl/bin/perl ${ORACLE_HOME}/rdbms/admin/catcon.pl -n 1 -1 /tmp/jvm -b initjvm ${ORACLE_HOME}/javavm/install/initjvm.sql;
host ${ORACLE_HOME}/perl/bin/perl ${ORACLE_HOME}/rdbms/admin/catcon.pl -n 1 -1 /tmp/jvm -b initxml ${ORACLE_HOME}/xdk/admin/initxml.sql;
host ${ORACLE_HOME}/perl/bin/perl ${ORACLE_HOME}/rdbms/admin/catcon.pl -n 1 -1 /tmp/jvm -b catjava ${ORACLE_HOME}/rdbms/admin/catjava.sql;
--TODO#

Prompt 6. Comprobando la instalación, El status debe ser  VALID
col comp_name format a30
col status format a15
set linesize window 
--#TODO
select comp_name, version, status
from dba_registry
where comp_name like '%JAVA%';
pause Analizar resultados, [ENTER] para continuar
--TODO#

Prompt 7.  Mostrando los componentes de Java en la BD
--#TODO
select count(*), object_type
from all_objects
where object_type like '%JAVA%'
group by object_type;
--TODO#
pause Analizar  resultados, [Enter] para continuar

Prompt 8. Ajustando parámetros
--#TODO
alter system set memory_max_target=2G scope=spfile;
alter system set memory_target=1G scope=spfile;
--TODO#

Pause 9. Listo! Reiniciando instancia, [enter] para continuar
shutdown immediate
startup

