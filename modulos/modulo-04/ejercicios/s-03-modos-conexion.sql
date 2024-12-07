--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

prompt 1. Configurando modo compartido. Conectando como sysdba en cdb$root
connect sys/system2 as sysdba

prompt 2. Configurando modo compartido

prompt 2.1 Configurando dispatchers
--#TODO
alter system 
  set dispatchers=
  '(ADDRESS=(PROTOCOL=TCP)(PORT=5000))',
  '(ADDRESS=(PROTOCOL=TCP)(PORT=5001))'
  scope=both;
--TODO#

prompt 2.2. Configurando shared servers
--#TODO
alter system shared_servers=3 scope=both;
--TODO#

prompt 3. Configurando DRCP

prompt 3.1 Iniciando el DRCP por default 
--#TODO
exec dbms_connection_pool.start_pool();
--TODO#

Prompt 3.2 Configturar min y max pooled servers
--#TODO
exec dbms_connection_pool.alter_param('', 'MINSIZE', '5');
--TODO#

Prompt max pooled servers
--#TODO
exec dbms_connection_pool.alter_param('', 'MAXSIZE', '10');
--TODO#

prompt 3.3 Configurar Tiempo máximo de vida sin uso en el pool (seg) - 1h
--#TODO
exec dbms_connection_pool.alter_param('', 'INACTIVITY_TIMEOUT', '3600');
--TODO#

prompt 3.4 Tiempo máximo de inactividad del pooled server -5 min
--#TODO
exec dbms_connection_pool.alter_param('', 'MAX_THINK_TIME', '300');
--TODO#

prompt 4. Configurando db_domain
--#TODO
alter system set db_domain='fi.unam' scope=spfile;
--TODO#

prompt 5. Notificar al listener los nuevos servicios
--#TODO
alter system register;
--TODO#

prompt 6. Mostrando los servicios que ofrece el listener
--#TODO
!lsnrctl services
--TODO#

pause Analizar resultados, [Enter] para reiniciar

prompt 7. reiniciando
shutdown immediate
startup 

prompt 8. Mostrando los servicios que ofrece el listener después del reinicio
!lsnrctl services

Prompt 9. Abrir netmgr, agregar nombres de servicio en tnsnames.ora [Enter] al terminar
Pause  10. Explorar tnsnames.ora, [Enter] al terminar de configurar

Prompt 11. Probar la conexión con el alias `free`, mostrar el modo de conexión
--#TODO
connect sys/system2@free as sysdba
select sid,server 
from v$session
where sid = sys_context('USERENV', 'SID');
--TODO#
pause [Enter] para continuar

Prompt 12. Probar la conexión con el alias `free_de`, mostrar el modo de conexión
--#TODO
connect sys/system2@free_de as sysdba
--TODO#
select sid, server from v$session where sid=sys_context('USERENV','SID');
pause [Enter] para continuar

Prompt 13. Probar la conexión con el alias `free_sh`, mostrar el modo de conexión
--#TODO
connect sys/system2@free_sh as sysdba
--TODO#
select sid, server from v$session where sid=sys_context('USERENV','SID');
pause [Enter] para continuar

Prompt 14. Probar la conexión con el alias `<iniciales>diplo_s2`, mostrar el modo de conexión
--#TODO
connect sys/system2@jhvdiplo_s2 as sysdba
--TODO#
select sid, server from v$session where sid=sys_context('USERENV','SID');
pause [Enter] para continuar

Prompt 15. Probar la conexión con el alias `<iniciales>diplo_s2_de`, mostrar el modo de conexión
--#TODO
connect sys/system2@jhvdiplo_s2_de as sysdba
--TODO#
select sid, server from v$session where sid=sys_context('USERENV','SID');
pause [Enter] para continuar

Prompt 16. Probar la conexión con el alias `<iniciales>diplo_s2_sh`, mostrar el modo de conexión
--#TODO
connect sys/system2@jhvdiplo_s2_sh as sysdba
--TODO#
select sid, server from v$session where sid=sys_context('USERENV','SID');
pause [Enter] para continuar

prompt 17. Mostrando datos de v$circuit ¿Qué significa cada registro?
--#TODO
select circuit,dispatcher,status,bytes/1024 kbs from v$circuit;
--TODO#
pause [Enter] para continuar

Prompt 18. Probar la conexión con el alias `<iniciales>diplo_s2_po`, mostrar el modo de conexión
connect sys/system2@jrcdiplo_s2_po as sysdba
--#TODO
select sid, server from v$session where sid=sys_context('USERENV','SID');
--TODO#