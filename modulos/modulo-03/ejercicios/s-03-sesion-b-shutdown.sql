--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>
Prompt Conectando como sys a la CDB$root
conn sys/system2 as sysdba

-- SHUTDOWN TRANSACTIONAL
Prompt Sesiones y transacciones activas:
col username format a15
col logon_time format a20
set linesize window
--#TODO

--TODO#

prompt Con base a la consulta, a continuación se ejecutará shutdown transactional
prompt Presionar [Enter] para ejecutar la instrucción 
pause  Posteriormente, ejecutar los comandos necesarios en la terminal 2 y/o 3 para que la instrucción sea exitosa
prompt ejecutando shutdown transactional ...
--#TODO

--TODO#

Prompt  Iniciando ..
startup 

Prompt Consultando la tabla de prueba (I)...
--#TODO

--TODO#
Prompt Revisar los datos de la tabla. ¿qué registros se conservaron y eliminaron ?
Pause [Enter] para continuar

-- SHUTDOWN IMMEDIATE
Prompt Abrir 2 terminales y en cada una ejecutar los scripts previos del escenario B
Pause Cuando estén listas las sesiones, presione [ENTER] para continuar

Prompt Sesiones y transacciones activas:
select s.sid,s.serial#,s.con_id,s.username,s.logon_time,s.type,
  t.xid,t.start_date
from v$session s
left outer join v$transaction t
  on s.saddr= t.ses_addr
where username is not null;


Pause Al ejecutar *shutdown immediate*, ¿habrá algún impedimento o se ejecutará sin contratiempos?
--#TODO

--TODO#

Prompt Reiniciando...
startup

Prompt Consultando la tabla de prueba (II)...
-- En este caso sólo debería estar el registro 20
select * from c##user01.t_b_prueba;

-- SHUTDOWN ABORT
Pause Abrir 2 terminales y en cada una ejecutar los scripts previos del escenario B [Cando estén listas las sesiones, presione ENTER para continuar]

Prompt Sesiones y transacciones activas:
select s.sid,s.serial#,s.con_id,s.username,s.logon_time,s.type,
  t.xid,t.start_date
from v$session s
left outer join v$transaction t
  on s.saddr= t.ses_addr
where username is not null;

Prompt Al ejecutar *shutdown abort*, ¿qué pasará con las sesiones abiertas?. 
Pause Al reiniciar la instancia, ¿qué datos habrá en la tabla de prueba?
--#TODO

--TODO#

Prompt Reiniciando...
startup

Prompt Consultando la tabla de prueba (III)...
--#TODO

--TODO#

Prompt Limpiando...

--#TODO

--TODO#

Prompt Listo!
