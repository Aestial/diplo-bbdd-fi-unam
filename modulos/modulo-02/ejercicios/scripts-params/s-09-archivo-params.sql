--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: Administración de parámetros

Prompt conectando como sysdba
connect sys/system1 as sysdba

Prompt creando un pfile a partir de un SPFILE
--#TODO

--TODO#

Prompt creando un pfile a partir de la instancia (debe estar iniciada)
--#TODO

--TODO#

Prompt modificar permisos ya que el archivo le pertenece a oracle
--#TODO

--TODO#

Pause Revisar archivos y detectar diferencias [Enter] para continuar

Prompt Mostrando el valor del parametro undo_retention antes del reinicio
--#TODO

--TODO#

Prompt agregando parametro undo_retention al pfile /tmp/pfile-memory.ora
--#TODO

--TODO#

Prompt deteniendo la instancia
shutdown immediate 

Prompt iniciando instancia empleando el pfile /tmp/pfile-memory.ora
--#TODO

--TODO#

Prompt comprobando el valor del parametro undo_retention
show parameter undo_retention

Prompt modificar el valor del parametro undo_retention en el spfile
Pause  ¿Qué pasará?

--#TODO

--TODO#
