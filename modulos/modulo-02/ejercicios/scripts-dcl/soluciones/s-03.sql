--@Autor: <Nombre del autor o autores> 
--@Fecha creación: <Fecha de creación> 
--@Descripción: <Breve descripción del contenido del script>

prompt 0. Generando spool
spool jrc-s-03-roles-spool.txt

Prompt 1. Conectando como sysdba
connect sys/system1@jrcdiplo_s1 as sysdba

Prompt 2.  Creando roles 

drop role if exists web_admin_role;
create role web_admin_role;
drop role if exists web_root_role;
create role web_root_role;

Prompt 3. Asignar privilegios al rol web_admin_role
grant create session, create table, create sequence to web_admin_role;

Prompt 4. Asignarle los privilegios que define el rol web_admin_role al rol web_root_role
grant web_admin_role to web_root_role;

Prompt 5. Creando usuario j_admin, asignarle roles y privilegios para propagar
drop user if exists j_admin cascade;
create user j_admin identified by j_admin;
grant web_admin_role to j_admin with admin option;

Prompt 6. Comprobar que el usuario j_admin puede entrar a sesión a través de su rol
connect j_admin/j_admin@jrcdiplo_s1
pause ¿ Fue posible entrar a sesión? Presionar enter para continuar

Prompt 7. Creando al usuario j_os_admin sin quota
connect sys/system1@jrcdiplo_s1 as sysdba
drop user if exists j_os_admin cascade;
create user j_os_admin identified by j_os_admin;

Prompt 8. Otorgando el rol a partir del usuario j_admin
connect j_admin/j_admin@jrcdiplo_s1
--esto es posible debido a  la cláusula with admin option
grant web_admin_role to j_os_admin;
pause ¿Funcionó ? Enter para continuar


Prompt 9. Comprobando resultados para el usuario j_os_admin
connect j_os_admin/j_os_admin@jrcdiplo_s1
pause ¿Fue posible conectarse como usuario j_os_admin?

Prompt 10. Realizar limpieza
-- Se emplea if exists

spool off
exit

