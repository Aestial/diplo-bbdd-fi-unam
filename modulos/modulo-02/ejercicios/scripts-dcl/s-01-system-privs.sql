--@Autor: Hernandez Vazquez Jaime
--@Fecha creación: 08/11/2024
--@Descripción: Muestra privilegios de un usuario

prompt 0. Generando spool
spool jhv-s-01-system-privs-spool.txt

prompt 1. Conectando como sys en jhvdiplo_s1
-- Por simplicidad se agrega el password. En un script real no se debe incluir
connect sys/system1@jhvdiplo_s1 as sysdba

prompt 2. Creando usuario jaime01
drop user if exists jaime01 cascade;
create user jaime01 identified by jaime quota unlimited on users;

prompt 3. Otorgar privilegios básicos a jaime01
grant create session, create table to jaime01;

prompt 4. Entrar a sesión como jaime01  y crear una tabla para validar
connect jaime01/jaime@jhvdiplo_s1 

prompt 5. Crear tabla de prueba para validar privilegios
create table test01(id number);

prompt 6. Crear una sesión como sysdba
connect  sys/system1@jhvdiplo_s1 as sysdba

prompt 7. Mostrando los datos de los privilegios

col grantee format a20
set linesize window
set pagesize 100

select grantee,privilege,admin_option
from  dba_sys_privs
where grantee='JAIME01';

pause 8. [Enter] para continuar, Realizar limpieza.
drop user jaime01 cascade;
--eliminar privilegio y usuario - idempotencia.


prompt Conclusiones: 
/*
Conclusiones 
.....
*/

Prompt Apagando spool y desconectando...
spool off 
exit