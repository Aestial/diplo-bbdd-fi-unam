--@Autor: <Nombre del autor o autores>
--@Fecha creación: <Fecha de creación>
--@Descripción: <Breve descripción del contenido del script>

Prompt Usuario que ejecuta el script:
!echo " ===> Usuario del S.O. para ejecutar: ${USER}"
Pause "Verificar que el usuario sea oracle. Ctrl-C Cancelar, Enter para continuar"

Prompt 1.  Autenticando como sysdba en cdb$root
connect sys/system2 as sysdba

define p_backup_dir='/home/oracle/backups/modulo-03'
!mkdir -p &p_backup_dir

Prompt 2. Intentando iniciar instancia modo nomount
--#TODO

--TODO#

Pause [Enter para corregir y reintentar]
--#TODO

--T0D0#

Prompt Reintentando el inicio en modo nomount
--#TODO

--TODO#
pause [¿ Se corrigió el error? Enter para continuar]

Prompt 3. Intentando pasar al modo mount
--#TODO

--TODO#

pause [Enter para corregir y reintentar]
--#TODO

--#TODO

Prompt Reintentando pasar al modo mount
--#TODO

--TODO#
Pause [¿ Se corrigió el error? Enter para continuar]

prompt 4. Intentar pasar al modo open
--#TODO

--TODO#

pause [Enter para corregir y reintentar]
--#TODO

--#TODO

prompt intentando abrir nuevamente 
--#TODO

--TODO#

pause [¿Se corrigió el error? Enter para restaurar datafile del TS users]
--#TODO

--TODO#

prompt intentando abrir nuevamente 
--#TODO

--TODO#

pause [¿Se corrigió el error?, Revisar alert Log!, Enter para corregir]

--#TODO

--#TODO

Prompt 5. Intentando iniciar nuevamente en modo OPEN
Prompt requiere autenticar y volver a iniciar
--#TODO

--#TODO

prompt 6. Mostrando status
--#TODO

--TODO#

Prompt 7. Comprobando que los archivos en el directorio backup hayan sido restaurados
Prompt la carpeta debe estar vacía
--#TODO

--TODO#

Pause [¿La Base ha regresado a la normalidad ? Enter para terminar]




