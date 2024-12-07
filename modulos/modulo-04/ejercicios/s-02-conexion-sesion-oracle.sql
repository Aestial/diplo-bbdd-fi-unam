--@Autor: Hernandez Vazquez Jaime 
--@Fecha creación: 06/12/2024
--@Descripción: <Breve descripción del contenido del script>


whenever sqlerror exit rollback;

prompt 1. Conectando como sysdba
connect sys/system2 as sysdba

Prompt 2. Mostrando las sesiones del usuario SYS 
set linesize window
col username format a10
col program format a40
--#TODO
select username,sid,serial#,server,paddr,status,type,program,
  to_char(logon_time, 'dd/mm/yyyy hh24:mi:ss') logon_time
from v$session
where username='SYS';
--TODO#

Prompt 3. Analizar resultados, Identificar a la sesión que está ejecutando este script.
pause  [Enter] para continuar
--#TODO
 --¿Cómo identificarla
 -- R: El tipo de sesión debe ser USER
--TODO#


prompt 4. En una terminal T2, iniciar  una sesión como sysdba
pause Presionar [Enter] una vez que se haya iniciado sesión

Prompt 5. Ejecutar nuevamente la consulta que muestre las sesiones existentes
run
pause  Identificar a la sesión de la terminal 2 [Enter] para continuar

Prompt 6. En T2  Habilitar el modo autotrace statistics
pause  Presionar [Enter] al haber habilitado este modo en T2
/*En T2  se debe ejecutar set autotrace on statistics */ 

Prompt 7. Ejecutar nuevamente la consulta que muestre las sesiones existentes
run

prompt 8. Identificar a la sesión adicional y asociada a la misma conexión que fue
prompt  creada debido al uso de autotrace statistics en T2 
pause [Enter] para continuar

Prompt 9. En T2 Cerrar la sesión sin terminar la conexión. Es decir, ejecutar el comando disconnect
Pause  [Enter] para continuar posterior al cierre de sesión en T2

Prompt 10. Mostrando nuevamente las sesiones del usuario SYS
run
pause ¿Qué sucedió con las 2 sesiones de T2 ? [Enter] para continuar

Prompt 11. Comprobar que la conexión en T2 sigue existiendo.
prompt Indicar el valor del atributo PADDR del server process identificado anteriormente

--#TODO
select sosid,username,program
from v$process
where paddr=hextoraw('&p_addr')
--TODO#

Prompt 12. Analizar resultados. ¿Qué resultado se espera?
Prompt Identificar el valor de la columna SOSID
Pause [Enter] para continuar

Prompt 13. Comprobar la existencia del server process de la conexión de T2
Prompt en sistema operativo. Indicar el valor del campo SOSID que representa
prompt el identificador del proceso a nivel del sistema operativo.
--#TODO
!ps -ef | grep -e &p_sosid | grep -v grep
--TODO#


pause  Analizar resultados, ¿cuál es el resultado esperado? [Enter] para continuar

Prompt 14. Terminar la conexión  en T2
pause [Enter] para continuar posterior al cierre de la sesión 

Prompt 15. Ejecutar nuevamente la consulta SQL para verificar la existencia de la conexión
run
Pause 16. Analizar resultados ,¿Qué sucedió con la conexión?
