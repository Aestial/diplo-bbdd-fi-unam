--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: Administración de parámetros

prompt autenticando como SYS
connect sys/system1 as sysdba

Prompt deteniendo instancia
shutdown immediate

Prompt Iniciando con pfile e-04-pfile.txt

define path='/unam-diplomado-bd/modulos/modulo-02/ejercicios/scripts-params'
startup pfile='&path/e-04-pfile.txt'

Prompt comprobando que la instancia fue iniciada con pfile
show parameter spfile

Pause [Enter] para continuar

Prompt Generando nuevo spfile e-05-spfile.ora
create spfile='&path/e-05-spfile.ora' from memory;

Prompt deteniendo instancia para reiniciar con nuevo spfile
shutdown immediate

Prompt creando el archivo e-06-spfile-param.txt
-- Creando un PFILE que apunta a un SPFILE
!echo "spfile=&path/e-05-spfile.ora" > e-06-spfile-param.txt

Prompt iniciando con el nuevo spfile e-05-spfile.ora a través de e-06-spfile-param.txt
startup pfile='$path/e-06-spfile-param.txt'

Prompt reiniciando con el nuevo spfile e-05-spfile.ora
show parameter spfile 

Prompt comprobando que la instancia fue iniciada con spfile
show parameter spfile 

Prompt Esto debe funcionar también: Apuntar directo al SPFILE empleando statup pfile...
Prompt Reiniciando...
shutdown immediate

Prompt iniciando con un SPFILE empleando el parametro pfile
-- No es posible emplear un SPFILE a través del parámetro pfile
startup pfile='&path/e-05-spfile.ora'

Prompt comprobando que la instancia fue iniciado con spfile
show parameter spfile 

Prompt reiniciando normalente
shutdown immediate
startup
