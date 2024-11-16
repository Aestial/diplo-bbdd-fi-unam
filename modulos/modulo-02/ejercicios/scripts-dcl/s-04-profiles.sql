--@Autor: Hernandez Vazquez Jaime
--@Fecha creación: 09/11/2024
--@Descripción: Creacion de perfiles y

Prompt 0. Generando spool
spool jhv-s-04-profiles-spool.txt

connect sys/system1@jhvdiplo_s1 as sysdba

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

Prompt Apagando spool y desconectando...
spool off
exit