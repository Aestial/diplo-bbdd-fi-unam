--@Autor: <Nombre del autor o autores> 
--@Fecha creación: <Fecha de creación> 
--@Descripción: <Breve descripción del contenido del script>

prompt 0. Generando spool
spool jrc-s-04-profiles-spool.txt
connect sys/system1@jrcdiplo_s1 as sysdba

Prompt 1. Crear un user profile
create profile session_limit_profile limit
  sessions_per_user 2;

Prompt 2. crear al usuario user01 y asignarle el profile
create user user01 identified by user01
  profile session_limit_profile;
grant create session to user01;

Prompt 3.  Abrir 3 terminales e intentar crear 3 sesiones con el usuario user01
pause ¿Funcionó la restricción del profile? Presionar enter para continuar

Prompt 4.  consultando datos de las sesiones del usuario user01
col username format a20
select sid, serial#,username,status,schemaname
from v$session
where username='USER01';

pause Cerrar sesiones del usuario USER01 antes de continuar

Prompt 5. Realizando limpieza
drop profile session_limit_profile cascade;
drop user user01 cascade;

spool off
exit