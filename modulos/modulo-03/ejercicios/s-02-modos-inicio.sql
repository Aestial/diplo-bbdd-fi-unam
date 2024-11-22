

--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

prompt 1. Autenticando como sysdba en gbldiplo_s2
connect sys/system2@gbldiplo_s2 as sysdba

prompt 2.1 Creando al usuario  user01
drop user if exists user01 cascade;
create user user01 identified by user01 quota unlimited on users;
grant create session, create table to user01;

prompt 2.2 creando al usuario  user02
drop user if exists user02 cascade;
create user user02 identified by user02 quota unlimited on users;
grant create session, create table to user01;
grant create session, create table to user02;

prompt 3. Abrir una terminal y entrar a sesión con el usuario user01
pause Presionar [Enter] para continuar

prompt 4. Iniciando en modo restringido en gbldiplo_s2
prompt ¿Será posible pasar al modo restringido con el usuario USER01 en sesión?
pause presionar [Enter] para confirmar la respuesta
--#TODO
--R: Sin problema, la BD podrá pasar al modo restrictivo.

--TODO#

prompt 5. En la terminal del usuario USER01 intentar crear una tabla de prueba
prompt e intentar crear un registro
pause ¿Qué sucederá ? [Enter] para continuar
--#TODO
-- Abrir terminal, autenticar con user01, crear la tabla e insertar
-- R: Sin problema, el usuario puede hacer cualquier acción porque ya estaba
--conectado antes de cambiar al modo restringido
--#TODO

Prompt 6. Intentando crear sesión con user02 en gbldiplo_s2
pause [¿Qué sucederá?, Enter para continuar]

--#TODO
-- R: El usuario USER02 no podrá iniciar sesión porque ya está el modo restringido
connect user02/user02@gbldiplo_s2
--TODO#

prompt 7. Autenticando como sysdba en gbldiplo_s2
connect sys/system2@gbldiplo_s2 as sysdba

Prompt asignando el privilegio restricted session a user02
--#TODO
grant restricted session to user02;
--TODO#

Prompt 8. Intentando crear sesión con user02
pause [¿Qué sucederá ?, Enter para continuar]

--#TODO
--R: El usuario podrá autenticar

--#TODO

Prompt 9. Regresando al modo no restringido en gbldiplo_s2
connect sys/system2@gbldiplo_s2 as sysdba
--#TODO

--TODO#

pause 10. Abrir en modo read only. La CDB debe detenerse [Enter para continuar]
-- ESta es una desventaja del modo read only. La BD tiene que detenerse
-- antes de pasarla a este modo. Activar y/o suspender evita tener que
-- cerrarla, los usuarios no tienen que desconectarse.
Prompt cambiando a cdb$root
connect sys/system2 as sysdba
shutdown immediate 
--#TODO

--TODO#

pause 11. Conectando como user02 ¿Qué sucederá? [Enter] para continuar
--#TODO
-- R: Error, un usuario común no podrá autenticar

--TODO#

pause 12. Intentando autenticar como sysdba ¿Qué sucederá? [Enter] para continuar
--#TODO
--R:  Sin problema. Un usuario administrador puede autenticar en modo read only
connect sys/system2@gbldiplo_s2 as sysdba
--TODO#

pause 13. Intentando autenticar como sysoper ¿Qué sucederá? [Enter] para continuar
--#TODO
--R:  Sin problema. Un usuario administrador puede autenticar en modo read only
connect  sys/system2@gbldiplo_s2 as sysoper
--TODO#

pause 14. Intentando crear una tabla en el esquema public ¿Qué sucederá? [Enter] para continuar
--#TODO
--R: La tabla no podrá ser creada
create table test01(id number);
--TODO#

Prompt 15. Regresar al modo de escritura y lectura
connect sys/system2 as sysdba
shutdown immediate 
--#TODO
startup open read write;
--TODO#

Prompt Listo