--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: 
--
Prompt Creando proxy PDB

Prompt 1. Creando spool del ejercicio 
spool /unam/diplo-bd/modulos/modulo-07/e-crea-pdbs/s-036-b-crea-pdb-spool.txt

Prompt 2. Conectando a D5 para crear liga y proxy PDB
connect sys/system5 as sysdba

Prompt 3. Creando liga
drop database link if exists jrc_proxy_link;
create database link jrc_proxy_link
   connect to c##jorge_remote identified by jorge
using 'FREE_D4';


Prompt 4.1 Verificando la existencia de la PDB jrcdiplo5_px1
   set serveroutput on
declare
   v_count number;
begin
   select count(*)
     into v_count
     from v$pdbs
    where name = 'JRCDIPLO5_PX1';
   if v_count > 0 then
      select count(*)
        into v_count
        from v$pdbs
       where name = 'JRCDIPLO5_PX1'
         and open_mode <> 'MOUNTED';
      if v_count > 0 then
         execute immediate 'alter pluggable database jrcdiplo5_px1 close';
      end if;
      execute immediate 'drop pluggable database jrcdiplo5_px1 including datafiles';
   end if;
end;
/

Prompt 4. Creando Proxy PDB
create pluggable database jrcdiplo5_px1 as proxy from jrcdiplo4_r1@jrc_proxy_link
   file_name_convert = ( '/opt/oracle/oradata/FREE/jrcdiplo4_r1','/opt/oracle/oradata/FREE/jrcdiplo5_px1' );

Prompt 5. Abrir la proxy PDB
alter pluggable database jrcdiplo5_px1 open read write;

Prompt 6. Accediendo a jrcdiplo4_r1 a través de la Proxy PDB
connect jorge_proxy/jorge@jrcdiplo5_px1


Prompt 7. Mostrando datos desde proxy ¿Qué mostrará con_name?
Prompt show con_name
select *
  from test_proxy;
pause Analizar resultados [Enter] para continuar

Prompt 8. Insertando datos desde proxy
insert into test_proxy values ( 2 );
commit;

Prompt 9. Validando en jrcdiplo4_r1
connect sys/system4@free_d4 as sysdba
alter session set container = jrcdiplo4_r1;
select *
  from jorge_proxy.test_proxy;
pause Analizar resultados [Enter] para hacer limpieza

Prompt Limpieza en D5
connect sys/system5 as sysdba
alter pluggable database jrcdiplo5_px1 close immediate;
drop pluggable database jrcdiplo5_px1 including datafiles;
drop database link jrc_proxy_link;

Prompt cerrando spool
spool off
disconnect