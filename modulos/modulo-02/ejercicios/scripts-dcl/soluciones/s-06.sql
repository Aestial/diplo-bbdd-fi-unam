--@Autor: <Nombre del autor o autores> 
--@Fecha creación: <Fecha de creación> 
--@Descripción: <Breve descripción del contenido del script>

prompt 0. Generando spool
spool jrc-s-06-archivo-pwd-spool.txt

define syslogon='sys/system1@jrcdiplo_s1 as sysdba'

Prompt 1. Conectando como sysdba
connect &syslogon

Prompt 2. Creando usuarios user01, user02 y user03
create user user01 identified by user01;
create user user02 identified by user02;
create user user03 identified by user03;

grant create session to user01;
grant create session to user02;
grant create session to user03;

Prompt 3. Asignando privilegios de administración
grant sysdba to user01;
grant sysoper to user02;
grant sysbackup to user03;

Prompt 4. Consultando los datos del archivo de passwords
col username format a15
col account_status format a20
col last_login format a40
set linesize window
select username,sysdba,sysoper,sysasm,sysbackup,sysdg,syskm,account_status,last_login
from v$pwfile_users;

Prompt Ejecutar shell script como usuario oracle
spool off
exit

