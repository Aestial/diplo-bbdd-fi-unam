--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

prompt 1. Este punto se ejecuta en la terminal antes de ejecutar este script

--La salida esperada es "ningún registro"  ya que no hay user process 
--solicitando conexiones, tampoco hay server processes porque la instancia
--está detenida.

--la opción -e se pone 2 veces para buscar renglones que contengan "sqlplus"
-- o la palabra "free". Aquí el alumno debe poner el nombre de su
-- instancia. La opción "-v" indica exclusión de las líneas que tengan la
-- palabra "grep"
--!ps -ef | grep -e free -e sqlplus | grep -v grep

prompt 2.  Se accede a este script empleando sqlplus /nolog
-- Se hace en la terminal
-- sqlplus /nolog

pause 3. Mostrando muevamente los procesos. ¿Qué debería mostrarse? [Enter] para continuar
--#TODO
!ps -ef | grep -e free -e sqlplus | grep -v grep
--TODO#

prompt 4. Conectando como sysdba en cdb$root
connect sys/system2 as sysdba

Pause 5.Ejecutando nuevamente el comando grep ¿Qué se obtendrá? [Enter] para continuar
--#TODO
!ps -ef | grep -e free -e sqlplus | grep -v grep
--TODO#

pause [Enter] para continuar

prompt 6. Mostrando el proceso asociado con el listener 
--#TODO
!ps -ef | grep -e LISTENER | grep -v grep
--TODO#

pause Analizar resultado, [Enter] para continuar

prompt 7. Iniciando instancia en modo nomount

startup nomount
pause Mostrando procesos. ¿ Qué se obtendrá? [Enter] para continuar

--#TODO
!ps -ef | grep -e free -e sqlplus | grep -v grep
--TODO#

pause Analizar resultado, [Enter] para continuar

prompt 8. Abriendo BD.
alter database mount; 
alter database open;

prompt 9. Cerrando sesión de sys
disconnect 

prompt creando una nueva sesión como sysdba
connect sys/system2 as sysdba

prompt mostrando los procesos de esta nueva conexión a nivel s.o.
Prompt ¿Qué diferencias existen con los identificadores de los procesos respecto
prompt a la consulta de la sesión anterior ?

--#TODO
!ps -ef | grep -e "LOCAL=YES" -e sqlplus | grep -v grep
--TODO#

prompt Anotar/observar los IDs de los procesos (user y server)
pause Presionar [Enter] hasta que se haya visualizado el reporte.

Prompt 10. Consultando user y server process empleando v$process

Prompt Indicar el id del user process
define user_pr=&user_process_id

Prompt Indicar el id del server process
define server_pr=&server_process_id

Prompt Realizando consulta en v$process
set linesize window
col program format a20
col sosid format a10
col tracefile format a50

--#TODO 
select sosid,pid,pname,username,program,tracefile,background,
 trunc(pga_used_mem/1024/1024,2) pga_used_mem_mb
from v$process where sosid in('&user_pr','&server_pr');

--TODO#

Prompt ¿Qué le pasó al user process ?

Prompt listo!
exit