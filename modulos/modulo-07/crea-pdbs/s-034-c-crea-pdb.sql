--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: 

Prompt 1. Creando spool del ejercicio
spool /unam/diplo-bd/modulos/modulo-07/e-crea-pdbs/s-034-c-crea-pdb-spool.txt

define pdb_dir='/opt/oracle/oradata/FREE/jrcdiplo5_s1'
define unplug_dir='/unam/diplo-bd/modulos/modulo-07/unplug'

Prompt 2. Conectando como sysdba en el contenedor D5 para realizar plug de la PDB
connect sys/system5 as sysdba

Prompt 3.  Abrir los archivos XML, actualizar las rutas de los datafiles
Pause Ubicación de los archivos: &unplug_dir, Presionar [Enter] al terminar con la actualización

prompt 4. Validar compatibilidad de la PDB, conectando como sysdba
set serveroutput on
declare
  v_compatible boolean;
begin
  v_compatible := dbms_pdb.check_plug_compatibility(
    pdb_descr_file => '&unplug_dir/jrcdiplo4_s1.xml',
    pdb_name       => 'jrcdiplo4_s1'
  );
  if v_compatible then
    dbms_output.put_line('COMPATIBLE!');
  else
    raise_application_error(-20001,'PDB jrcdiplo4_s1 no es compatible con esta CDB');
  end if;
end;
/

pause Validar resultados [enter] para continuar

prompt 5. Agregar la nueva PDB, es decir, hacer plug.
create pluggable database jrcdiplo5_s1
  using '&unplug_dir/jrcdiplo4_s1.xml'
  file_name_convert=(
    '&unplug_dir',
    '&pdb_dir'
  );

prompt 6. Mostrando datos de las PDBS
show pdbs
set linesize window
col pdb_name format a20
select pdb_id,pdb_name,status from dba_pdbs;
pause Analizar [enter] para continuar

prompt 7. Abriendo PDB 
alter pluggable database jrcdiplo5_s1 open read write;

prompt 8. conectar a jrcdiplo5_s1
alter session set container=jrcdiplo5_s1;

prompt 9. Mostrando metadatos de la tabla de prueba
col table_name format a30
select table_name,tablespace_name 
from dba_tables 
where owner='JORGE07'
and table_name='TEST';

Prompt Mostrando datos de la tabla
select * from jorge07.test;

pause 10. Analizar resultado [Enter] para comenzar con Limpieza
alter session set container=cdb$root;
alter pluggable database jrcdiplo5_s1 close immediate;
drop pluggable database jrcdiplo5_s1 including datafiles;

!rm &unplug_dir/jrcdiplo4_s1.xml
!rm &unplug_dir/"*.dbf"

Prompt cerrando spool
spool off
disconnect 