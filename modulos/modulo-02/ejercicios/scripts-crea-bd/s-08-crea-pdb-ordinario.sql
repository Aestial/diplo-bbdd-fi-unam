--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: Creación de una PDB

Prompt Conectando como sys
connect sys/system2 as sysdba

Prompt creando PDB
create pluggable database jhvdiplo_s2
  admin user jhv_admin identified by jhv_admin
  path_prefix = '/opt/oracle/oradata/FREE'
  file_name_convert = ('/pdbseed/', '/jhvdiplo_s2/');

Prompt abrir la PDB
alter pluggable database jhvdiplo_s2 open;


Prompt guardar el estado de la PDB
alter pluggable database jhvdiplo_s2 save state;
