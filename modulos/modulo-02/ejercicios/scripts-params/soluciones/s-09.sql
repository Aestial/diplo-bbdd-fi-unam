--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: Administración de parámetros

Prompt conectando como sysdba
connect sys/system2 as sysdba

Prompt creando un pfile a partir de un SPFILE
create pfile='/tmp/pfile-spfile.ora' from spfile;


Prompt creando un pfile a partir de la instancia (debe estar iniciada)
create pfile='/tmp/pfile-memory.ora' from memory;

Prompt modificar permisos ya que el archivo le pertenece a oracle
!sudo chmod 777 /tmp/pfile-spfile.ora
!sudo chmod 777 /tmp/pfile-memory.ora

Pause Revisar archivos y detectar diferencias [Enter] para continuar

Prompt Mostrando el valor del parametro undo_retention antes de reinicio - nivel sesión
show parameter undo_retention

Prompt agregando parametro undo_retention al pfile /tmp/pfile-memory.ora
!echo "undo_retention=1000">>/tmp/pfile-memory.ora

Prompt deteniendo la instancia
shutdown immediate 

Prompt iniciando instancia empleando el pfile /tmp/pfile-memory.ora
startup pfile='/tmp/pfile-memory.ora'

Prompt comprobando el valor del parametro undo_retention
show parameter undo_retention

Prompt modificar el valor del parametro undo_retention en el spfile
Pause  ¿Qué pasará?
alter system undo_retention=1500 scope=spfile;
