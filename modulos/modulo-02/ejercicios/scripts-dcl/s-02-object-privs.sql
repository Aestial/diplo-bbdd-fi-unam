--@Autor: Hernandez Vazquez Jaime
--@Fecha creación: 08/11/2024
--@Descripción: Script de creacion de usuarios y privilegios

prompt 0. Generando spool
spool jhv-s-02-object-privs-spool.txt

Prompt 1 . Conectando como sysdba
connect sys/system1@jhvdiplo_s1 as sysdba

Prompt 2. Crear usuarios de prueba
create user jaime01 identified by jaime01 quota unlimited on users;
create user guest01 identified by guest01 quota unlimited on users;

Prompt 3. Otorgar algunos system privs  a jaime01
grant create table, create session to jaime01;

Prompt 4. Otorgar solo create session a guest01
grant create session to guest01;

Prompt 5. Crear usuario guest02 a partir dela instrucción grant
--notar la creación del usuario guest02 y al mismo tiempo  se le otorga el
--privilegio para crear sesiones
grant create session to guest02 identified by guest02;
alter user guest02 quota 10M on users;

Prompt 6. Permitir que guest02 pueda otorgar privilegios
-- Permitir que guest02 pueda otorgar privs de objetos pertenecientes a cualquier esquema
-- notar que la palabra grant aparece 2 veces ya que el privilegio
-- de sistema se llama 'grant any object privilege'
grant GRANT ANY OBJECT privilege to guest02;

Prompt 7. Conectando como jaime01
connect jaime01/jaime01@jhvdiplo_s1

Prompt 8. Creando tabla y registro
create table test01(id number,nombre varchar2(20));
insert into test01 values(1, 'uno');

Prompt 9. Verificar que guest01 no puede acceder a los datos de jaime01
connect guest01/guest01@jhvdiplo_s1
select * from jaime01.test01;

pause ¿Fue posible consultar los datos de test01 ? Presionar enter para continuar

Prompt 10. Otorgarle permisos a guest01 para que pueda consultar datos de jaime01
connect jaime01/jaime01@jhvdiplo_s1
grant select on test01 to guest01;

Prompt 11. Comprobando acceso a la tabla test01 empleando al usuario guest01
connect guest01/guest01@jhvdiplo_s1
select * from jaime01.test01;

pause ¿Fue posible consultar los datos de jaime01.test01 ? Presionar enter para continuar 

Prompt 12. Conectando como guest02
--guest02 le dará permiso de inserción a guest01 sobre los registros de
-- jaime01.test01
connect guest02/guest02@jhvdiplo_s1

Prompt 13. Otorgar permiso para que guest02 le permita a guest01 insertar
grant insert on jaime01.test01 to guest01;

Prompt 14. Comprobando los permisos de inserción para el usuario guest01
connect guest01/guest01@jhvdiplo_s1
insert into jaime01.test01 values(2, 'dos');

pause ¿Fue posible insertar los datos en jaime01.test01? Presionar enter para continuar 

Prompt 15. Realizando limpieza
connect sys/system1@jhvdiplo_s1 as sysdba
drop user jaime01 cascade;
drop user guest01 cascade;
drop user guest02 cascade;

/* 
Conclusiones
*/

Prompt Apagando spool y desconectando...
spool off
exit