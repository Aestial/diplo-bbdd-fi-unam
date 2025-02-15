--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: 
--
Prompt Creando proxy PDB

Prompt 1. Creando spool del ejercicio 
spool /unam/diplo-bd/modulos/modulo-07/e-crea-pdbs/s-036-a-crea-pdb-spool.txt

Prompt 2. Conectando como sysdba en D4
connect sys/system4 as sysdba

Prompt 3. Creando common user en D4
drop user if exists c##jorge_remote cascade; 
create user c##jorge_remote identified by jorge container=all;
grant create session,create pluggable database to c##jorge_remote container=all;

Prompt 5.1 Verificando la existencia de la PDB jrcdiplo4_r1
set serveroutput on 
declare
  v_count number;
begin
  select count(*) into v_count
  from v$pdbs
  where name='JRCDIPLO4_R1';
  if v_count  > 0 then
    select count(*) into v_count 
    from v$pdbs
    where name='JRCDIPLO4_R1'
    and open_mode<>'MOUNTED';
    if v_count >0 then  
      execute immediate 'alter pluggable database jrcdiplo4_r1 close';
    end if;
    execute immediate 'drop pluggable database jrcdiplo4_r1 including datafiles';
  end if;
end;
/

Prompt 5.2 Creando una nueva PDB <iniciales>diplo4_r1 en el contenedor D4
create pluggable database jrcdiplo4_r1
  admin user admin_s4 identified by admin_s4
  path_prefix='/opt/oracle/oradata/FREE/'
  file_name_convert=('pdbseed/','jrcdiplo4_r1/');

prompt 6. Abriendo y conectando en jrcdiplo4_r1
alter pluggable database jrcdiplo4_r1 open read write;
alter session set container=jrcdiplo4_r1;

Prompt 7. Creando un tablespace en  jrcdiplo4_r1
create tablespace  test_proxy_ts
datafile '/opt/oracle/oradata/FREE/jrcdiplo4_r1/test_proxy.dbf'
  size 10M autoextend  on next 1M;

Prompt 8. Creando un usuario de prueba en  jrcdiplo4_r1, asignar privs
create user jorge_proxy identified by jorge 
 default tablespace test_proxy_ts
 quota unlimited on test_proxy_ts;
grant create session, create table to jorge_proxy;

Prompt 9. Creando tabla  test_proxy, insertando datos
create table jorge_proxy.test_proxy(id number);
insert into jorge_proxy.test_proxy values (1);
commit;

Prompt 10. Mostrando los datos de prueba 
select * from jorge_proxy.test_proxy;
pause Revisar datos, [Enter] para continuar

Prompt Ejecutar el siguiente script en la CDB del contenedor D5 para crear la  proxy PDB

Prompt Cerrando spool
spool off
disconnect 














