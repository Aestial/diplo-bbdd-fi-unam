--@Autor:  Jaime Hernandez Vazquez
--@Fecha creación:  10/01/2025
--@Descripción:

whenever sqlerror exit rollback

Prompt 1. Agregado contenido al spool del ejercicio
spool jhv-e-08c-cifrar-ts-oracle.txt

Prompt 2. En cdb$root crear un TS de prueba para ser cifrado (ajustar iniciales)
connect sys/system2 as sysdba

Prompt 3. Validando usuario a nivel sistema operativo
begin
  if sys_context('USERENV','OS_USER') != 'oracle' then
    raise_application_error(-20001,
     'El script debe ser ejecutado con el usuario oracle del s.o.');
  end if;
end;
/

prompt 4. Creando TS para ser cifrado
--#TODO
drop tablespace if exists jhv_m05_enc_tbs including contents and datafiles;
create tablespace jhv_m05_enc_tbs
  datafile '/opt/oracle/oradata/FREE/jhv_m05_enc_tbs_01.dbf' size 20m
  extent management local autoallocate
  segment space management auto;
--TODO#

Prompt 5. Cifrando el contenido del TS. 
--#TODO
alter tablespace jhv_m05_enc_tbs encryption ONLINE encrypt;
--TODO#

Prompt 6. Comprobando la configuración de los TS 
select tablespace_name, con_id,encrypted from cdb_tablespaces;
pause Analizar resultados, [Enter] para continuar

Prompt 7. Creando un common user c##<nombre>05, asignar cuota al TS cifrado
--#TODO
drop user if exists c##jaime05 cascade;
create user c##jaime05 identified by jaime;
grant create table, create session to c##jaime05;
alter user c##jaime05 quota unlimited on users container=current;
alter user c##jaime05 quota unlimited on jhv_m05_enc_tbs container=current;
--TODO#

Prompt 8. Creando objetos y guardar sus datos en  el TS cifrado.
--#TODO
create table c##jaime05.mensaje_seguro(
  id number,
  mensaje varchar2(20)
) tablespace jhv_m05_enc_tbs;

create index c##jaime05.mensaje_seguro_ix on c##jaime05.mensaje_seguro(mensaje)
tablespace jhv_m05_enc_tbs;

insert into c##jaime05.mensaje_seguro (id, mensaje) values (1, 'mensaje 1');
insert into c##jaime05.mensaje_seguro (id, mensaje) values (2, 'mensaje 2');
commit;
--TODO#

Prompt Mostrando datos de una tabla con datos cifrados.
Pause ¿Qué se muestra al consultar tablas cifradas ? [Enter] para continuar
select * from c##jaime05.mensaje_seguro;

Prompt 9. Crear la misma tabla  y datos pero en un TS no cifrado.
--#TODO
create table c##jaime05.mensaje_inseguro(
  id number,
  mensaje varchar2(20)
) tablespace users;

create index c##jaime05.mensaje_inseguro_ix on c##jaime05.mensaje_inseguro(mensaje)
tablespace users;

insert into c##jaime05.mensaje_inseguro (id, mensaje) values (1, 'mensaje 1');
insert into c##jaime05.mensaje_inseguro (id, mensaje) values (2, 'mensaje 2');
commit;
--TODO#

Prompt 10. Forzando escritura a data files
--#TODO
alter system checkpoint;
--TODO#

Prompt 11. Realizar la búsqueda del texto en el TS cifrado.
Pause ¿Qué se debería mostrar al ejecutar el comando de búsqueda ? [Enter] para continuar

-- El comando strings permite buscar texto en archivos binarios.
--#TODO
!strings /opt/oracle/oradata/FREE/jhv_m05_enc_tbs_01.dbf | grep "mensaje"
--TODO#

Prompt  Realizar la búsqueda del texto en users.dbf. El texto debe aparecer en la salida
Pause ¿Qué se debería mostrar al ejecutar el comando de búsqueda ? [Enter] para continuar
--#TODO
!strings /opt/oracle/oradata/FREE/users.dbf | grep "mensaje"
--TODO#

--Limpieza al final
Prompt 12. Eliminando el TS
drop tablespace if exists jhv_m05_enc_tbs including contents and datafiles;

Prompt Listo!
spool off
disconnect
