--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>
Prompt Conectando como sys en CDB$root
conn sys/system2 as sysdba

Prompt Mostrar sesiones y transacciones activas
col username format a15
col logon_time format a20
set linesize window
--#TODO
alter session set nls_date_format='dd/mm/yyyy hh24:mi:ss';
select s.sid,s.serial#,s.con_id,s.username,s.logon_time,s.type,t.xid,t.start_date
from v$session s
left outer join v$transaction t
  on s.saddr= t.ses_addr
where username is not null;
--TODO#


prompt Con base a la consulta,  A continuación se ejecutará shutdown normal
prompt Presionar [Enter] para ejecutar la instrucción 
pause  Posteriormente, ejecutar los comandos necesarios en la terminal 2 para que la instrucción sea exitosa
prompt ejecutando shutdown normal ...
--#TODO

--TODO#

Prompt shutdown normal concluido con éxito 
Prompt Iniciando nuevamente...
startup
