--@Autor: <Nombre del autor o autores> 
--@Fecha creación: <Fecha de creación> 
--@Descripción: <Breve descripción del contenido del script>

prompt 0. Generando spool
spool jrc-s-02-object-privs-spool.txt

Prompt 1 . Conectando como sysdba
connect sys/system1@jrcdiplo_s1 as sysdba

Prompt 2. Crear usuarios de prueba
create user jorge01 identified by jorge01 quota unlimited on users;
create user guest01 identified by guest01 quota unlimited on users;

Prompt 3. Otorgar algunos system privs  a jorge01
grant create table, create session to  jorge01;

Prompt 4. Otorgar solo create session a guest01
grant  create session to guest01;

Prompt 5. Crear usuario guest02 a partir dela instrucción grant
--notar la creación del usuario gest02 y al mismo tiempo  se le otorga el
--privilegio para crear sesiones
grant create session to guest02 identified by guest02;
alter user guest02 quota 10M on users;


Prompt 6. Permitir que guest02 pueda otorgar privilegios
-- Permitir que guest02 pueda otorgar privs de objetos pertenecientes a cualquier esquema
-- notar que la palabra grant aparece 2 veces ya que el privilegio
-- de sistema se llama 'grant any object privilege'
grant GRANT ANY OBJECT PRIVILEGE to guest02;


Prompt 7. Conectando como jorge01
connect jorge01/jorge01@jrcdiplo_s1

Prompt 8. Creando tabla y registro
create table test01(id number,nombre varchar2(20));
insert into test01 values(1,'uno');

Prompt 9. Verificar que guest01 no puede acceder a los datos de jorge01
connect guest01/guest01@jrcdiplo_s1
select * from jorge01.test01;
pause ¿Fue posible consultar los datos de test01 ? Presionar enter para continuar

Prompt 10. Otorgarle permisos a guest01 para que pueda consultar datos
connect jorge01/jorge01@jrcdiplo_s1
grant select on test01 to guest01;


Prompt 11. Comprobando acceso a la tabla test01 empleando al usuario guest01
connect guest01/guest01@jrcdiplo_s1
select * from jorge01.test01;
pause ¿Fue posible consultar los datos de jorge01.test01? Presionar enter para continuar

Prompt 12. Conectando como guest02
--guest02 le dará permiso de inserción a guest01 sobre los registros de
-- jorge01.test01
connect guest02/guest02@jrcdiplo_s1

Prompt 13. Otorgar permiso para que guest02 le permita a guest01 insertar
grant insert on jorge01.test01 to guest01;

Prompt 14. Comprobando los permisos de inserción para el usuario guest01
connect guest01/guest01@jrcdiplo_s1
insert into jorge01.test01 values(2,'dos');
pause ¿Fue posible insertar? Enter para continuar

Prompt 15. Realizando limpieza
connect sys/system1@jrcdiplo_s1 as sysdba
drop user jorge01 cascade;
drop user guest01 cascade;
drop user gutest02 cascade;

/*
COnclusiones
*/

Prompt terminando spool
spool off
exit
