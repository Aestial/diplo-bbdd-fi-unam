--@Autor:          Jorge A. Rodriguez C
--@Fecha creación:  dd/mm/yyyy
--@Descripción: Administración de parámetros

prompt autenticando como SYS
connect sys/system1 as sysdba

Prompt deteniendo instancia
shutdown immediate

Prompt Iniciando con pfile e-04-pfile.txt

define path='/unam-diplomado-bd/modulos/modulo-02'
--#TODO

--TODO#

Prompt comprobando que la instancia fue iniciada con pfile
--#TODO

--TODO#

Pause [Enter] para continuar

Prompt Generando nuevo spfile e-05-spfile.ora
--#TODO

--TODO#

Prompt deteniendo instancia para reiniciar con nuevo spfile
shutdown immediate

Prompt creando el archivo e-06-spfile-param.txt
--#TODO

--TODO#

Prompt reiniciando con el nuevo spfile e-05-spfile.ora
--#TODO

--TODO#

Prompt comprobando que la instancia fue iniciada con spfile
show parameter spfile 



