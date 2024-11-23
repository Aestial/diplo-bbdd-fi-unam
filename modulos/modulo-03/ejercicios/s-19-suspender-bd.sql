prompt conectando como sysdba
connect sys/system2 as sysdba

prompt creando usuarios
create user c##user03_s1 identified by c##user03_s1 quota unlimited on users;
grant create session, create table to c##user03_s1;

pause Reiniciando instancia [Enter] para continuar
shutdown immediate
startup

prompt Abrir una nueva terminal T1 y entrar a sesión con c##user03_s1
Pause [Enter] para continuar

prompt suspendiendo la BD Considerado que el usuario c##user03_s1 esta en sesión, 
pause ¿Qué sucederá?, [Enter] para continuar

--#TODO

--#TODO

prompt Salir de sesión en T1 , intentar autenticar nuevamente
Pause ¿Qué sucederá? Considerar que la BD está suspendida. [Enter para continuar]
--#TODO

--TODO#

prompt En la terminal T1, intentar crear una tabla y un registro.
pause ¿Qué sucederá? [Enter] para continuar
--#TODO

--TODO#

Prompt mostrando status de la BD 
select database_status from v$instance;

prompt ¿Qué sucederá si se termina la suspensión?
-- la sesión en T1 se reanuda y al tabla se crea.
pause [Enter] para continuar
--#TODO

--TODO#

Prompt mostrando status de la BD 
--#TODO

--TODO#

Prompt realizando limpieza. En T1 salir de sesión 
pause [Enter] para continuar
drop user c##user03_s1 cascade;
