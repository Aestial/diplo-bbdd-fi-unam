define syslogon='sys/system2 as sysdba'
col file_name format a65
col name format a65
set pagesize 100
set linesize window

Prompt  Consultando data files empleando dba_data_files
connect &syslogon

select file_name,file_id,relative_fno,tablespace_name,bytes/(1024*1024) bytes_mb,
  status,autoextensible,increment_by,user_bytes/(1024*1024) user_bytes_mb,
  (bytes-user_bytes)/1024 header_kb,online_status
from dba_data_files;

--status del data file: online available, invalid
--status online: sysoff, system, offline, online, recover

Prompt Consultando data files de v$datafile

select name,file#,creation_change#,to_char(creation_time,'dd/mm/yyyy hh24:mi:ss')
  creation_time,checkpoint_change#,to_char(checkpoint_time,'dd/mm/yyyy hh24:mi:ss')
  checkpoint_time,last_change#,to_char(last_time,'dd/mm/yyyy hh24:mi:ss')
  last_time
from v$datafile;

Pause Analizar salida, [enter] para continuar

Prompt Mostrando datos del header del datafile
select file#,name,error,recover,checkpoint_change#,
  to_char(checkpoint_time,'dd/mm/yyyy hh24:mi:ss') checkpoint_time
from v$datafile_header;

Pause Analizar salida, [enter] para continuar

Prompt mostrando datos de archivos temporales.
select file_id,file_name,tablespace_name,status,
  autoextensible,bytes/(1024*1024) bytes_mb 
from  dba_temp_files;

Pause Analizar salida, [enter] para continuar