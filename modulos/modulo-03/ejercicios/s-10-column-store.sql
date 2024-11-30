-- Ejercicio 1. Habilitación del IM Column Store
-- Crear un script `s-01-column-store.sql` que realice las siguientes acciones:

Prompt Autenticando como sysdba en cdb$root
connect sys/system2 as sysdba

whenever sqlerror exit rollback


Prompt 1. Actualizando el valor de memory_target
--#TODO
alter system set memory_target=1G scope=spfile;
--TODO#

Prompt 2. Alterando parametro inmemory_size
--#TODO
alter system set inmemory_size=100M scope=spfile;
--TODO#

Prompt 3. Reiniciando instancia
shutdown immediate
startup

Prompt 4. Mostrando parametro inmemory_size
--#TODO
show parameter inmemory_size
--TODO#

Prompt 5. Creando usuario user03imc en <iniciales>diplo_s2
alter session set container=jhvdiplo_s2;
drop user if exists user03imc cascade;
create user user03imc identified by user03imc quota unlimited on users;
grant create session, create table to user03imc;

Prompt 6. Iniciando sesión como user03imc
connect user03imc/user03imc@jhvdiplo_s2

--Datos de películas del sitio imdb.com
Prompt 7. Creando tabla movie
--#TODO
create table movie(
  id number,
  title varchar2(4000),
  m_year number(4,0),
  duration number(10,2),
  budget number,
  rating number(5,2),
  votes number(10),
  r1 number(10,2),
  r2 number(10,2),
  r3 number(10,2),
  r4 number(10,2),
  r5 number(10,2),
  r6 number(10,2),
  r7 number(10,2),
  r8 number(10,2),
  r9 number(10,2),
  r10 number(10,2),
  mpaa varchar2(50),
  m_action number(1,0),
  comedy number(1,0),
  drama number(1,0),
  Documentary number(1,0),
  romance number(1,0),
  short number(1,0)
);
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