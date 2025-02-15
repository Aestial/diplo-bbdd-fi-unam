--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: 

Prompt 1. Creando spool del ejercicio
clear screen
spool /unam/diplo-bd/modulos/modulo-07/e-crea-pdbs/s-034-b-crea-pdb-spool.txt

define pdb_src='/opt/oracle/oradata/FREE/jrcdiplo4_s1'
define unplug_dir='/unam/diplo-bd/modulos/modulo-07/unplug'

Prompt 2. Conectando como sysdba en el contenedor D4
connect sys/system4 as sysdba

Prompt 3. Verificando la existencia de la PDB
set serveroutput on
declare
  v_count number;
begin
  select count(*) into v_count
  from v$pdbs
  where name='JRCDIPLO4_S1';
  if v_count > 0 then
    dbms_output.put_line('La PDB existe, validar si esta cerrada');
    select count(*) into v_count
    from v$pdbs
    where open_mode <> 'MOUNTED';
    if v_count > 0 then
      dbms_output.put_line('Cerrando PDB');
      execute immediate 'alter pluggable database jrcdiplo4_s1 close immediate';     
    end if;
    dbms_output.put_line('Eliminando PDB');
    execute immediate 'drop pluggable database jrcdiplo4_s1 including datafiles';
  end if;
end;
/

Prompt 4. Creando una nueva PDB <iniciales>diplo4_s1 en el contenedor D4
create pluggable database jrcdiplo4_s1
  admin user admin_s4  identified by admin_s4
  storage (maxsize 1G)
  default tablespace s4_tbs
    datafile '&pdb_src/s4_tbs01.dbf' size 20m
    autoextend on
  path_prefix='/opt/oracle/oradata/FREE/'
  file_name_convert=(
    'pdbseed/',
    'jrcdiplo4_s1/'
  );

prompt 5. Abriendo PDB
alter pluggable database jrcdiplo4_s1 open read write;

prompt 6. Creando usuario y tabla de prueba en la nueva PDB
alter session set container=jrcdiplo4_s1;
drop user if exists jorge07 cascade;
create user jorge07 identified by jorge quota unlimited on s4_tbs;
grant create table, create session to jorge07;
create table jorge07.test(id number);
insert into jorge07.test values (1);
insert into jorge07.test values (2);
insert into jorge07.test values (3);
commit;

Prompt 7. Cerrar la nueva PDB antes de hacer unplug
alter session set container=cdb$root;
alter pluggable database jrcdiplo4_s1 close immediate;

Prompt 8. Hacer unplug de la PDB
alter pluggable database jrcdiplo4_s1 unplug 
 into '&pdb_src/jrcdiplo4_s1.xml';

Prompt 9. Mostrando los datos de las PDBs  después de hacer unplug
Prompt Mostrando datos de las PDBs con SQL*Plus
show pdbs

Prompt Mostrando datos de las PDBs  (dba_pdbs)
col pdb_name format a30
select pdb_id,pdb_name,status from dba_pdbs;
pause Analizar resultados. ¿Qué sucedió con los datos de la PDB ? [enter] para continuar

Prompt 10. Mover los datafiles y archivo XML a &unplug_dir
!mkdir -p &unplug_dir
-- permisos 777 para que el usuario oracle pueda escribir en el directorio
!chmod 777 &unplug_dir
Prompt Indicar el password del usuario oracle para mover los archivos
!su -c 'mv &pdb_src/*.dbf &pdb_src/jrcdiplo4_s1.xml &unplug_dir' oracle

prompt 11. Mostrar el contenido del directorio &unplug_dir
!ls -l &unplug_dir

prompt 12. Eliminar la PDB con status unplugged
drop pluggable database jrcdiplo4_s1;

prompt 13. Ejecutar el siguiente script en el contenedor D5 para realizar plug de la PDB
prompt  Apagando spool
spool off
disconnect
