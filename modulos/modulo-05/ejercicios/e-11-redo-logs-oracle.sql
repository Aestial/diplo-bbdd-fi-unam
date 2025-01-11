define syslogon='sys/system2 as sysdba'
define userlogon='jorge05/jorge'

Prompt  1. mostrando Redo logs en S.O
--!find /u*/app/oracle/oradata/JRCDIP02/redo* -name "*redo*.log" -type f -exec ls -l {} \;

-- completar 2 al 4

Prompt 5 . Agregar grupos nuevos.

connect &syslogon

Prompt creando grupo 4
alter database add logfile group 4 (
  '/u12/app/oracle/oradata/JRCDIP02/redo04a_60.log',
  '/u13/app/oracle/oradata/JRCDIP02/redo04b_60.log'
) size 60m blocksize 512;

Prompt creando grupo 5
alter database add logfile group 5 (
  '/u12/app/oracle/oradata/JRCDIP02/redo05a_60.log',
  '/u13/app/oracle/oradata/JRCDIP02/redo05b_60.log'
) size 60m blocksize 512;

Prompt creando grupo 6
alter database add logfile group 6 (
  '/u12/app/oracle/oradata/JRCDIP02/redo06a_60.log',
  '/u13/app/oracle/oradata/JRCDIP02/redo06b_60.log'
) size 60m blocksize 512;

Prompt 6. Agregar miembros

alter database add logfile member 
  '/u14/app/oracle/oradata/JRCDIP02/redo04c_60.log' to group 4;

alter database add logfile member 
  '/u14/app/oracle/oradata/JRCDIP02/redo05c_60.log' to group 5;

alter database add logfile member 
  '/u14/app/oracle/oradata/JRCDIP02/redo06c_60.log' to group 6;


Prompt 7. consultar nuevamente  grupos.
set linesize window 

select * from v$log;
Pause  Analizar y [enter] para continuar

Prompt 8. consultar nuevamente  miembros
col member format  a50 
select * from v$logfile;

Prompt 9 Forzar log switch para liberar grupos 1,2 y 3

set serveroutput on 
declare
  v_group number;
begin
  loop
    select group# into v_group from v$log where status ='CURRENT';
    dbms_output.put_line('Grupo en uso: '||v_group);
    if v_group in (1,2,3) then
      execute immediate 'alter system switch logfile';
    else 
      exit;
    end if;
  end loop;
end;
/

Prompt 10. Confirmando grupo actual.
select * from v$log;
Pause Analizar y [enter] para continuar

Prompt 11.  Validando que los grupo 1 a 3 no tengan status active

declare
  v_count number;
begin
  select count(*) into v_count from v$log where status = 'ACTIVE';
  if v_count > 0 then
    dbms_output.put_line('Forzando checkpoint para sicronizar data files con db buffer');
    execute immediate 'alter system checkpoint';
  end if;
end;
/

Prompt 12. Confirmando que no existen grupos con status ACTIVE.
select * from v$log;
Pause Analizar y [enter] para continuar

Prompt 13. Eliminar grupos 1, 2, y 3

alter database drop logfile  group  1;
alter database drop logfile  group  2;
alter database drop logfile  group  3;

Prompt 14. Confirmando que se han eliminado grupos 1, 2 y 3.
select * from v$log;
Pause Analizar y [enter] para continuar OJO! validar que todo esta OK.

Prompt 15 y 16 Eliminar archivos via S.O.
Prompt eliminando redo logs grupo 1
!rm /u12/app/oracle/oradata/JRCDIP02/redo01a.log
!rm /u13/app/oracle/oradata/JRCDIP02/redo01b.log
!rm /u14/app/oracle/oradata/JRCDIP02/redo01c.log

Prompt eliminando redo logs grupo 2
!rm /u12/app/oracle/oradata/JRCDIP02/redo02a.log
!rm /u13/app/oracle/oradata/JRCDIP02/redo02b.log
!rm /u14/app/oracle/oradata/JRCDIP02/redo02c.log

Prompt eliminando redo logs grupo 3
!rm /u12/app/oracle/oradata/JRCDIP02/redo03a.log
!rm /u13/app/oracle/oradata/JRCDIP02/redo03b.log
!rm /u14/app/oracle/oradata/JRCDIP02/redo03c.log

Prompt 17. revisar archivos esperados a nivel s.o.
!find /u*/app/oracle/oradata/JRCDIP02/redo* -name "*redo*.log" -type f -exec ls -l {} \;

exit
