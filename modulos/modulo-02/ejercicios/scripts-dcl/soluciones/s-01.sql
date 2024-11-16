--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

prompt 0. Generando spool
spool jrc-s-01-system-privs-spool.txt

prompt 1. Conectando como sys en jrcdiplo_s1
-- Por simplicidad se agrega el password. En un script real no se debe incluir
connect sys/system1@jrcdiplo_s1 as sysdba

prompt 2. Creando usuario jorge01
create user jorge01 identified by jorge quota unlimited on users;

prompt 3. Otorgar privilegios básicos a jorge01
grant create session, create table to jorge01;

prompt 4. Entrar a sesión como jorge01  y crear una tabla para validar
connect jorge01/jorge@jrcdiplo_s1

prompt 5. Crear tabla de prueba para validar privilegios
create table test01(id number);

prompt 6. Crear una sesión como sysdba
connect  sys/system1@jrcdiplo_s1 as sysdba

prompt 7. Mostrando los datos de los privilegios

col grantee format a20
set linesize window
select grantee,privilege,admin_option
from  dba_sys_privs
where grantee='JORGE01';

pause 8. [Enter] para continuar, Realizar limpieza.
drop user jorge01 cascade;

Prompt conclusiones:
/*
Mis .....
.....
....
*/

Prompt apagar spool
spool off
exit
