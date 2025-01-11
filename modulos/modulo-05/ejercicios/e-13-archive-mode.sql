define syslogon='sys/system2 as sysdba'

Prompt Habilitar archive mode 

Prompt respaldando spfile  a través del pfile.
connect &syslogon
create pfile from spfile;

Prompt configurando parámetros
--procesos ARC
alter system set log_archive_max_processes=5 scope=spfile;

--configuración de directorios
alter system set log_archive_dest_1='LOCATION=/u41/archivelogs/JRCDIP02/disk_a MANDATORY' scope=spfile;
alter system set log_archive_dest_2='LOCATION=/u42/archivelogs/JRCDIP02/disk_b' scope=spfile;

--formato del archivo
alter system set log_archive_format='arch_jrcdip02_%t_%s_%r.arc' scope=spfile;

--copias mínimas  para considerar el proceso como exitoso.
alter system set log_archive_min_succeed_dest=1 scope=spfile;

Prompt Mostrando parámetros antes de continuar.

show spparameter log_archive_max_processes
show spparameter log_archive_dest_1
show spparameter log_archive_dest_2
show spparameter log_archive_format
show spparameter log_archive_min_succeed_dest

Pause Revisar configuracion, [enter] para reiniciar instancia en modo mount

shutdown immediate

Prompt iniciando en modo mount
startup mount

Prompt habilitar el modo archive
alter database archivelog;

Prompt abrir la BD  para comprobar configuración
alter database open;

Prompt comprobando resultados
archive log list

Pause Revisar, [enter] para continuar

Prompt respaldando nuevamente el spfile 
create pfile from spfile;

Prompt mostrando procesos ARCn
!ps -ef | grep ora_arc

Prompt Listo.
exit





