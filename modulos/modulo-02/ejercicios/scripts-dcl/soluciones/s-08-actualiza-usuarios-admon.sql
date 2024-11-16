--@Autor: <Nombre del autor o autores> 
--@Fecha creación: <Fecha de creación> 
--@Descripción: <Breve descripción del contenido del script>

prompt 0. Generando spool
spool jrc-s-08-actualiza-usuarios-admon-spool.txt

--emplear el password admin1234# ya que fue modificado al crear el archivo.
define syslogon='sys/admin1234#@jrcdiplo_s1 as sysdba'

prompt conectando como sysdba
connect &syslogon

Prompt 1. consultando archivo de passwords antes de agregar a los usuarios
Prompt Solo el usuario sys debe estar en el archivo

col username format a20
col account_status format a20
col last_login format a40
set linesize window
select username,sysdba,sysoper,sysasm,sysbackup,sysdg,syskm,account_status,last_login
from v$pwfile_users;
Pause [Enter para continuar]

Prompt 2. Reasignando privilegios de administración a los 3 usuarios
grant sysdba to user01;
grant sysoper to user02;
grant sysbackup to user03;

Prompt 3. consultando nuevamente:
select username,sysdba,sysoper,sysasm,sysbackup,sysdg,syskm,account_status,last_login 
from v$pwfile_users;
Pause [Enter para continuar]

Prompt 4. Actualizar (sincronizar) el password de sys desde cdb$root
alter session set container=cdb$root;
alter user sys identified by system1;
alter session set container=jrcdiplo_s1;

Prompt limpieza
drop user user01 cascade;
drop user user02 cascade;
drop user user03 cascade;

spool off