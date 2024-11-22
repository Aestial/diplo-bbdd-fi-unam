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
