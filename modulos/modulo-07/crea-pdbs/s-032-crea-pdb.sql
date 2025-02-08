--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: 
spool /unam/diplo-bd/modulos/modulo-07/e-crea-pdbs/s-032-crea-pdbs-spool.txt

Prompt creando PDB a partir de otra 

Prompt conectar a jrcdiplo3_s1 para insertar datos de prueba
connect sys/system3@jrcdiplo3_s1 as sysdba

Prompt creando un usuario de prueba
declare
  v_count number;
begin
   select count(*) into v_count from dba_users where username='JORGE07';
   if v_count > 0 then
     execute immediate 'drop user JORGE07 cascade';
   end if;
end;
/

Prompt creando usuario y tabla de prueba
create user jorge07 identified by jorge quota unlimited on users;
grant create session, create table to jorge07;

create table jorge07.test(id number);
insert into jorge07.test values(1);
insert into jorge07.test values(2);
insert into jorge07.test values(3);
commit;

Prompt conectando a cdb$root;
alter session set container=cdb$root;

Prompt clonando jrcdiplo3_s3 a partir de jrcdiplo3_s1
create pluggable database jrcdiplo3_s3 from jrcdiplo3_s1
  path_prefix='/opt/oracle/oradata/FREE'
  file_name_convert=('/jrcdiplo3_s1','jrcdiplo3_s3');


Prompt Mostrando los datos de las PDBs con SQL*Plus
col file_name format A60
show pdbs
pause [Enter] para continuar

Prompt abrir pdb nueva
alter pluggable database jrcdiplo3_s3 open;

Prompt mostrando datafiles de la CDB
set linesize window
select file_id, file_name from cdb_data_files;
pause [Enter] para continuar

Prompt verificando los datos clonados
alter session set container=jrcdiplo3_s3;
select * from jorge07.test;

pause Revisar datos clonados, [Enter] para continuar

Prompt Limpieza
alter session set container=cdb$root;

prompt eliminando jrcdiplo3_s3
alter pluggable database jhvdiplo3_s3 close;
drop pluggable database jhvdiplo3_s3 including datafiles;

spool off
exit

