-- Ejercicio 1. Habilitación del IM Column Store
-- Crear un script `s-01-column-store.sql` que realice las siguientes acciones:

Prompt Autenticando como sysdba en cdb$root
connect sys/system2 as sysdba

whenever sqlerror exit rollback


Prompt 1. Actualizando el valor de memory_target
--#TODO

--TODO#

Prompt 2. Alterando parametro inmemory_size
--#TODO

--TODO#

Prompt 3. Reiniciando instancia
shutdown immediate
startup

Prompt 4. Mostrando parametro inmemory_size
--#TODO

--TODO#

Prompt 5. Creando usuario user03imc en <iniciales>diplo_s2
alter session set container=jrcdiplo_s2;
drop user if exists user03imc cascade;
create user user03imc identified by user03imc quota unlimited on users;
grant create session, create table to user03imc;

Prompt 6. Iniciando sesión como user03imc
connect user03imc/user03imc@jrcdiplo_s2

--Datos de películas del sitio imdb.com
Prompt 7. Creando tabla movie
--#TODO

--TODO#

Pause Ejecutar script s-11-movie-carga-inicial.sql [Enter] para iniciar
Prompt 8. Realizar la carga de datos

Promp 9. Poblando tabla
set feedback off 
@@s-11-movie-carga-inicial.sql
set feedback on

Prompt 10. Contando registros, se esperan 58788
select count(*) from movie;
Pause Revisar resultados [Enter] para hacer commit

Prompt haciendo commit 
commit;

Prompt Listo!