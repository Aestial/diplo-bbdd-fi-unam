--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: 

Prompt 1. Spool del ejercicio
spool /unam/diplo-bd/modulos/modulo-07/e-crea-pdbs/s-033-crea-pdb-spool.txt

prompt 2. Conectando a cdb$root en CDB Remota (D2)
connect sys/system2@free_d2 as sysdba

Prompt 3. Crear un common user en cdb$root remota (D2)
drop user if exists c##jorge_remote cascade;
create user c##jorge_remote identified by jorge container=all;
grant create session, create pluggable database to c##jorge_remote container=all;

Prompt 4. Creando DB link en CDB local  (D3)
connect sys/system3 as sysdba
drop database link if exists clone_link;
create database link clone_link
  connect to c##jorge_remote identified by jorge  using 'FREE_D2';

prompt 5. Creando pdb en host D3
set serveroutput on
declare
  v_count number;
begin
  select count(*) into v_count
  from v$pdbs
  where name='JRCDIPLO3_S3';
  if v_count > 0 then
    dbms_output.put_line('La PDB existe, validar si esta cerrada');
    select count(*) into v_count
    from v$pdbs
    where open_mode <> 'MOUNTED';
    if v_count > 0 then
      dbms_output.put_line('Cerrando PDB');
      execute immediate 'alter pluggable database jrcdiplo3_s3 close immediate';     
    end if;
    dbms_output.put_line('Eliminando PDB');
    execute immediate 'drop pluggable database jrcdiplo3_s3 including datafiles';
  end if;
end;
/

create pluggable database jrcdiplo3_s3
  from jrcdiplo_s2@clone_link
  file_name_convert=(
    '/opt/oracle/oradata/FREE/jrcdiplo_s2',
    '/opt/oracle/oradata/FREE/jrcdiplo3_s3'
  );

prompt 6. Abriendo y verificando la nueva pdb
alter pluggable database jrcdiplo3_s3 open read write;

Prompt 7. Mostrando los tablespaces de la CBD
select tablespace_name,con_id,status from cdb_tablespaces;
Pause Analizar nuevos tablespaces, [Enter] para continuar.

Prompt 8. Mostrando datafiles de la CDB
set linesize window
col file_name format A70
select tablespace_name,con_id,status,file_id,file_name from cdb_data_files;

pause Analizar resultados, [Enter] para continuar con Limpieza

prompt 9. Borrar PDB
--borrando PDB clone
alter pluggable database jrcdiplo3_s3 close;
drop pluggable database jrcdiplo3_s3 including datafiles;
--borrando liga
drop database link if exists clone_link;

prompt 10. Eliminando usuario en host D2 
connect sys/system2@free_d2 as sysdba
--borrar common user
drop user if exists c##jorge_remote cascade;

spool off
exit


 