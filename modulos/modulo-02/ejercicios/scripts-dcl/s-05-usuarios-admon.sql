--@Autor: <Nombre del autor o autores> 
--@Fecha creación: 11/08/2024
--@Descripción: <Breve descripción del contenido del script>

prompt 0. Generando spool
spool jhv-s-05-usuarios-admon-spool.txt

Prompt 1. Conectando como sysdba
connect sys/system1@jhvdiplo_s1 as sysdba

Prompt creando usuario user01
create user user01 identified by user01 quota unlimited on users;

Prompt 2 Otorgar privilegios para crear tablas y sesiones
grant create table, create session to user01;

Prompt 3 Asignar privilegios de sistema y privilegios de admon
grant sysdba, sysoper to user01;

Prompt 4. Creando a los usuarios user02 y user03 
create user user02 identified by user02 quota unlimited on users;    
grant create session, create table to user02;
create user user03 identified by user03 quota unlimited on users;    
grant create session, create table to user03;

Prompt 5. Conectando como user01,mostrar esquema, crear tabla, otorgar privs
connect user01/user01@jhvdiplo_s1
pause ¿Qué usuario y esquema se asignan con esta autenticación?  Enter para continuar
Prompt usuario:
show user
Prompt esquema:
select sys_context('USERENV', 'CURRENT_SCHEMA') as schema;

Prompt Crear tabla de prueba
create table test(id number);
insert into test values(1);
commit;
select * from test;

Prompt Otorgar permisos de lectura a TODOS los usuarios 
grant select on test to public;

Prompt 6. Autenticar como user01 as sysdba, mostrar datos 
connect user01/user01@jhvdiplo_s1 as sysdba
pause ¿Qué usuario y esquema se asignan con esta autenticación?  Enter para continuar
Prompt usuario:
show user
Prompt esquema:
select sys_context('USERENV','CURRENT_SCHEMA') as schema;
pause ¿qué pasará al ejecutar select * from test ? Enter para continuar
select * from test;
pause ¿qué pasará al ejecutar select * from user01.test ? Enter para continuar
select * from user01.test;

Prompt 7. Autenticar como sysoper con user01
connect user01/user01@jhvdiplo_s1 as sysoper
pause ¿Qué usuario y esquema se asignan con esta autenticación?  Enter para continuar
Prompt usuario:
show user
Prompt esquema:
select sys_context('USERENV','CURRENT_SCHEMA') as schema;
pause ¿qué pasará al ejecutar select * from test ? Enter para continuar
select * from test;
pause ¿qué pasará al ejecutar select * from user01.test ? Enter para continuar
select * from user01.test;

prompt 8. Consultar la tabla pública test desde cualquier usario: user02, user03
Prompt conectando como user02
connect user02/user02@jhvdiplo_s1
pause ¿qué pasará al consultar los datos de la tabla user01.test? Enter para continuar
select * from user01.test;
Prompt conectando como user03
connect user03/user03@jhvdiplo_s1
pause ¿qué pasará al consultar los datos de la tabla test? Enter para continuar
select * from user01.test;

Prompt 9. Limpieza
connect sys/system1@jhvdiplo_s1 as sysdba
drop user user01 cascade;
drop user user02 cascade;
drop user user03 cascade;

Prompt Apagando spool y desconectando...
spool off 
exit